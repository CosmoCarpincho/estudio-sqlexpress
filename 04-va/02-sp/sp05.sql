create or alter procedure usp_gasto_mensual
as
begin
    select 
        year(ms.FechaMovimiento) as Anio,
        month(ms.FechaMovimiento) as Mes,
        sum(mc.PrecioUnitario * ms.CantidadModificada) as GastoTotal
    from MovimientoCompra mc
    join MovimientoStock ms on ms.IdMovimiento = mc.IdMovimiento
    where ms.TipoMovimiento = 'Ingreso'
    group by year(ms.FechaMovimiento), month(ms.FechaMovimiento)
    order by Anio, Mes;
end;
go

exec usp_gasto_mensual;
go

create or alter procedure usp_gasto_anual
as
begin
    select 
        year(ms.FechaMovimiento) as Anio,
        sum(mc.PrecioUnitario * ms.CantidadModificada) as GastoTotal
    from MovimientoCompra mc
    join MovimientoStock ms on ms.IdMovimiento = mc.IdMovimiento
    where ms.TipoMovimiento = 'Ingreso'
    group by year(ms.FechaMovimiento)
    order by Anio;
end;
go

exec usp_gasto_anual;
go

create or alter procedure usp_gasto_periodo
    @FechaInicio datetime,
    @FechaFin datetime
as
begin
    select 
        sum(mc.PrecioUnitario * ms.CantidadModificada) as GastoTotal
    from MovimientoCompra mc
    join MovimientoStock ms on ms.IdMovimiento = mc.IdMovimiento
    where ms.TipoMovimiento = 'Ingreso'
      and ms.FechaMovimiento between @FechaInicio and @FechaFin;
end;
go

exec usp_gasto_periodo @FechaInicio = '2023-01-01',  @FechaFin = '2025-06-05';
go

create or alter procedure usp_gasto_por_producto
    @CodProducto int = null
as
begin
    select
        P.CodProducto,
        P.Descripcion as Producto,
        sum(mc.PrecioUnitario * ms.CantidadModificada) as GastoTotal
    from MovimientoCompra mc
    join MovimientoStock ms on ms.IdMovimiento = mc.IdMovimiento
    join Producto P on P.CodProducto = ms.CodProducto
    where ms.TipoMovimiento = 'Ingreso'
      and (@CodProducto is null or P.CodProducto = @CodProducto)
    group by P.CodProducto, P.Descripcion
    order by GastoTotal desc;
end;
go


exec usp_gasto_por_producto;
exec usp_gasto_por_producto 64;
go

create or alter procedure usp_gasto_anual_por_producto
    @CodProducto int = null
as
begin
    select
        year(ms.FechaMovimiento) as Anio,
        p.CodProducto,
        p.Descripcion as Producto,
        sum(mc.PrecioUnitario * ms.CantidadModificada) as GastoTotal
    from MovimientoCompra mc
    join MovimientoStock ms on ms.IdMovimiento = mc.IdMovimiento
    join Producto p on p.CodProducto = ms.CodProducto
    where ms.TipoMovimiento = 'Ingreso'
      and (@CodProducto is null or p.CodProducto = @CodProducto)
    group by year(ms.FechaMovimiento), p.CodProducto, p.Descripcion
    order by Anio, GastoTotal desc;
end;
go

exec usp_gasto_anual_por_producto;
go

create or alter procedure usp_gasto_por_proveedor
    @IdProveedor int = null
as
begin
    select
        PR.IdProveedor,
        PR.Nombre as Proveedor,
        sum(mc.PrecioUnitario * ms.CantidadModificada) as GastoTotal
    from MovimientoCompra mc
    join MovimientoStock ms on ms.IdMovimiento = mc.IdMovimiento
    join OrdenCompra OC on OC.NroCompra = mc.NroCompra
    join Proveedor PR on PR.IdProveedor = OC.IdProveedor
    where ms.TipoMovimiento = 'Ingreso'
      and (@IdProveedor is null or PR.IdProveedor = @IdProveedor)
    group by PR.IdProveedor, PR.Nombre
    order by GastoTotal desc;
end;
go

exec usp_gasto_por_proveedor;
exec usp_gasto_por_proveedor @IdProveedor = 37; -- Tambo Don Juan
go

