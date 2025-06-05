create or alter procedure usp_obtener_produccion_mensual_por_producto
    @CodProducto int = null
as
begin
    set nocount on;

    select
        p.CodProducto,
        p.Descripcion,
        year(ms.FechaMovimiento) as Anio,
        month(ms.FechaMovimiento) as Mes,
        sum(ms.CantidadModificada) as CantidadProducida
    from MovimientoStock ms
    inner join MovimientoFabricacion mf on ms.IdMovimiento = mf.IdMovimiento
    inner join Producto p on ms.CodProducto = p.CodProducto
    where ms.TipoMovimiento = 'Ingreso'
      and (@CodProducto is null or p.CodProducto = @CodProducto)
    group by
        p.CodProducto,
        p.Descripcion,
        year(ms.FechaMovimiento),
        month(ms.FechaMovimiento)
    order by
        p.CodProducto,
        Anio,
        Mes;
end
go

exec usp_obtener_produccion_mensual_por_producto;  -- Sin parámetro devuelve todos los productos
exec usp_obtener_produccion_mensual_por_producto 36;
go

create or alter procedure usp_obtener_produccion_anual_por_producto
    @CodProducto int = null
as
begin
    set nocount on;

    select
        p.CodProducto,
        p.Descripcion,
        year(ms.FechaMovimiento) as Anio,
        sum(ms.CantidadModificada) as CantidadProducida
    from MovimientoStock ms
    inner join MovimientoFabricacion mf on ms.IdMovimiento = mf.IdMovimiento
    inner join Producto p on ms.CodProducto = p.CodProducto
    where ms.TipoMovimiento = 'Ingreso'
      and (@CodProducto is null or p.CodProducto = @CodProducto)
    group by
        p.CodProducto,
        p.Descripcion,
        year(ms.FechaMovimiento)
    order by
        p.CodProducto,
        Anio;
end
go

exec usp_obtener_produccion_anual_por_producto;     -- Sin parámetro devuelve todos los productos anualmente
exec usp_obtener_produccion_anual_por_producto 36;
go



create or alter procedure usp_obtener_produccion_mensual_todos_productos_por_fecha
    @FechaInicio datetime = null,
    @FechaFin datetime = null
as
begin
    set nocount on;

    /*
    Obtiene la producción mensual de todos los productos,
    sumando movimientos de tipo 'Ingreso' relacionados con fabricación.
    Permite filtrar por rango de fechas opcional.
    */

    select
        p.CodProducto,
        p.Descripcion,
        year(ms.FechaMovimiento) as Anio,
        month(ms.FechaMovimiento) as Mes,
        sum(ms.CantidadModificada) as CantidadProducida
    from MovimientoStock ms
    inner join MovimientoFabricacion mf on ms.IdMovimiento = mf.IdMovimiento
    inner join Producto p on ms.CodProducto = p.CodProducto
    where ms.TipoMovimiento = 'Ingreso'
      and (@FechaInicio is null or ms.FechaMovimiento >= @FechaInicio)
      and (@FechaFin is null or ms.FechaMovimiento <= @FechaFin)
    group by
        p.CodProducto,
        p.Descripcion,
        year(ms.FechaMovimiento),
        month(ms.FechaMovimiento)
    order by
        p.CodProducto,
        Anio,
        Mes;
end
go 


exec usp_obtener_produccion_mensual_todos_productos_por_fecha;  -- Parámetros opcionales, sin pasar devuelve todo el historial
exec usp_obtener_produccion_mensual_todos_productos_por_fecha '2023-04-01', '2024-06-01'
go
