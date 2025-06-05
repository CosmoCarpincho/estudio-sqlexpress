/************************************************************
 *                      SP PRINCIPALES                      *
 ************************************************************/


create or alter procedure usp_cantidad_usuarios_por_sector
as
begin
    select 
        s.Nombre as NombreSector,
        count(distinct u.IdUsuario) as CantidadUsuarios
    from Sector s
        left join PermisoOrdenSector pos on s.IdSector = pos.IdSector
        left join Permiso p on pos.IdPermiso = p.IdPermiso
        left join RolPermiso rp on rp.IdPermiso = p.IdPermiso
        left join Rol r on r.IdRol = rp.IdRol
        left join UsuarioRol ur on ur.IdRol = r.IdRol
        left join Usuario u on u.IdUsuario = ur.IdUsuario
    group by s.Nombre
    order by NombreSector;
end
go

-- exec usp_cantidad_usuarios_por_sector;
-- go

create or alter procedure usp_usuarios_pertenecen_a_sector
    @NombreSector nvarchar(100)
as
begin
    set nocount on;

    select distinct
        u.IdUsuario,
        u.Nombre,
        u.Apellido,
        u.Email
    from Sector s
        inner join PermisoOrdenSector pos on s.IdSector = pos.IdSector
        inner join Permiso p on pos.IdPermiso = p.IdPermiso
        inner join RolPermiso rp on rp.IdPermiso = p.IdPermiso
        inner join UsuarioRol ur on ur.IdRol = rp.IdRol
        inner join Usuario u on u.IdUsuario = ur.IdUsuario
    where s.Nombre = @NombreSector
    order by u.Apellido, u.Nombre;
end;
go

-- exec usp_usuarios_pertenecen_a_sector 'Dulceria';
-- go
    


-------- 2

create or alter procedure usp_stock_por_producto
    @CodProducto int
as
begin
    set nocount on;

    select 
        d.IdDeposito,
        d.Nombre as NombreDeposito,
        sum(ms.CantidadModificada) as StockActual,
        um.Nombre as UnidadMedida
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.CodProducto = @CodProducto
    group by d.IdDeposito, d.Nombre, um.IdUM, um.Nombre
    having sum(ms.CantidadModificada) <> 0
    order by d.Nombre;
end;
go

-- exec usp_stock_por_producto @CodProducto = 94 --Leche cruda
-- exec usp_stock_por_producto 52 -- Separador carton
-- exec usp_stock_por_producto 14 --Leche en Polvo
-- exec usp_stock_por_producto 51 -- Bolsa papel kraft
-- go


create or alter procedure usp_stock_por_deposito
    @IdDeposito int
as
begin
    set nocount on;

    select 
        d.IdDeposito,
        d.Nombre as NombreDeposito,
        p.CodProducto,
        p.Descripcion as NombreProducto,
        sum(ms.CantidadModificada) as StockActual,
        um.Nombre as UnidadMedida
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join Producto p on p.CodProducto = ms.CodProducto
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.IdDeposito = @IdDeposito
    group by d.IdDeposito, d.Nombre, p.CodProducto, p.Descripcion, um.Nombre
    having sum(ms.CantidadModificada) <> 0
    order by p.Descripcion;
end;
go

-- exec usp_stock_por_deposito @IdDeposito = 1;
-- exec usp_stock_por_deposito @IdDeposito = 12;
-- exec usp_stock_por_deposito @IdDeposito = 6;
-- exec usp_stock_por_deposito @IdDeposito = 22;
-- go


--- 3
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

-- exec usp_obtener_produccion_mensual_por_producto;  -- Sin parámetro devuelve todos los productos
-- exec usp_obtener_produccion_mensual_por_producto 36;
-- go

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

-- exec usp_obtener_produccion_anual_por_producto;     -- Sin parámetro devuelve todos los productos anualmente
-- exec usp_obtener_produccion_anual_por_producto 36;
-- go

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

-- exec usp_gasto_mensual;
-- go


/************************************************************
 *                       SP EXTRAS                          *
 ************************************************************/

create or alter procedure usp_cantidad_de_usuarios_por_permiso
as
begin
    set nocount on;

    select 
        p.IdPermiso,
        p.Nombre as NombrePermiso,
        count(distinct ur.IdUsuario) as CantidadUsuarios
    from Permiso p
        left join RolPermiso rp on rp.IdPermiso = p.IdPermiso
        left join UsuarioRol ur on ur.IdRol = rp.IdRol
    group by p.IdPermiso, p.Nombre
    order by p.Nombre;
end;
go

-- exec usp_cantidad_de_usuarios_por_permiso
-- go

create or alter procedure usp_cantidad_de_usuarios_por_rol
as
begin
    set nocount on;

    select 
        r.IdRol,
        r.Nombre as NombreRol,
        count(distinct ur.IdUsuario) as CantidadUsuarios
    from Rol r
        left join UsuarioRol ur on ur.IdRol = r.IdRol
    group by r.IdRol, r.Nombre
    order by r.Nombre;
end;

go

-- exec usp_cantidad_de_usuarios_por_rol
-- go


create or alter procedure usp_permisos_de_usuario
    @IdUsuario int
as
begin
    set nocount on;

    select
        p.IdPermiso,
        p.Nombre as NombrePermiso,
        p.Descripcion as DescripcionPermiso,
        pos.TipoOrden,
        pos.Accion,
        s.Nombre as NombreSector,
        r.Nombre as NombreRol
    from Usuario u
        inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
        inner join Rol r on ur.IdRol = r.IdRol
        inner join RolPermiso rp on r.IdRol = rp.IdRol
        inner join Permiso p on rp.IdPermiso = p.IdPermiso
        left join PermisoOrdenSector pos on p.IdPermiso = pos.IdPermiso
        left join Sector s on pos.IdSector = s.IdSector
    where u.IdUsuario = @IdUsuario
    order by NombrePermiso, TipoOrden, Accion, NombreSector;
end;
go

-- declare @IdUsuario int = (select IdUsuario from UsuarioROl ur join Rol r on ur.IdRol = r.IdRol where r.Nombre = 'Admin');
-- print @IdUsuario

-- exec usp_permisos_de_usuario @IdUsuario
-- exec usp_permisos_de_usuario 33
-- go


create or alter procedure usp_cantidad_usuarios_por_sector_orden
as
begin
    select 
        pos.IdSector,
        s.Nombre as NombreSector,
        pos.TipoOrden,       
        count(distinct u.IdUsuario) as CantidadUsuarios
    from PermisoOrdenSector pos
        left join Sector s on s.IdSector = pos.IdSector  -- join para nombre del sector
        left join Permiso p on pos.IdPermiso = p.IdPermiso
        left join RolPermiso rp on rp.IdPermiso = p.IdPermiso
        left join Rol r on r.IdRol = rp.IdRol
        left join UsuarioRol ur on ur.IdRol = r.IdRol
        left join Usuario u on u.IdUsuario = ur.IdUsuario
    group by pos.IdSector, s.Nombre, pos.TipoOrden
    order by pos.IdSector, pos.TipoOrden;
end
go

-- exec usp_cantidad_usuarios_por_sector_orden;
-- go


create or alter procedure usp_sector_orden_del_usuario
    @IdUsuario int
as
begin
    set nocount on;

    select distinct
        s.IdSector,
        s.Nombre,
        pos.TipoOrden
    from Usuario u
        inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
        inner join Rol r on ur.IdRol = r.IdRol
        inner join RolPermiso rp on r.IdRol = rp.IdRol
        inner join Permiso p on rp.IdPermiso = p.IdPermiso
        inner join PermisoOrdenSector pos on p.IdPermiso = pos.IdPermiso
        inner join Sector s on pos.IdSector = s.IdSector
    where u.IdUsuario = @IdUsuario
    order by s.IdSector, pos.TipoOrden;
end;
go



-- exec usp_sector_orden_del_usuario 1;
-- exec usp_sector_orden_del_usuario 33;
-- go

create or alter procedure usp_sector_ordenes_usuarios_info
as
begin
    set nocount on;

    select
        s.IdSector,
        s.Nombre as NombreSector,
        pos.TipoOrden,
        pos.Accion,
        p.IdPermiso,
        p.Nombre as NombrePermiso,
        u.IdUsuario,
        u.Nombre as NombreUsuario,
        u.Apellido as ApellidoUsuario,
        r.IdRol,
        r.Nombre as NombreRol
    from Sector s
        inner join PermisoOrdenSector pos on s.IdSector = pos.IdSector
        inner join Permiso p on pos.IdPermiso = p.IdPermiso
        inner join RolPermiso rp on p.IdPermiso = rp.IdPermiso
        inner join Rol r on rp.IdRol = r.IdRol
        inner join UsuarioRol ur on r.IdRol = ur.IdRol
        inner join Usuario u on ur.IdUsuario = u.IdUsuario
    order by s.IdSector, pos.TipoOrden, pos.Accion, u.Nombre, u.Apellido;
end;
go

-- exec usp_sector_ordenes_usuarios_info

------- 2

create or alter procedure usp_stock_por_producto_y_deposito
    @CodProducto int,
    @IdDeposito int
as
begin
    set nocount on;

    select 
        d.IdDeposito,
        d.Nombre as NombreDeposito,
        p.CodProducto,
        p.Descripcion as NombreProducto,
        sum(ms.CantidadModificada) as StockActual,
        um.Nombre as UnidadMedida
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join Producto p on p.CodProducto = ms.CodProducto
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.CodProducto = @CodProducto
      and ms.IdDeposito = @IdDeposito
    group by d.IdDeposito, d.Nombre, p.CodProducto, p.Descripcion, um.Nombre
    having sum(ms.CantidadModificada) <> 0
    order by p.Descripcion;
end;
go

-- exec usp_stock_por_producto_y_deposito @CodProducto = 94, @IdDeposito = 3;
-- exec usp_stock_por_producto_y_deposito @CodProducto = 73, @IdDeposito = 12;
-- go




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


-- exec usp_obtener_produccion_mensual_todos_productos_por_fecha;  -- Parámetros opcionales, sin pasar devuelve todo el historial
-- exec usp_obtener_produccion_mensual_todos_productos_por_fecha '2023-04-01', '2024-06-01'
-- go


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

-- exec usp_gasto_anual;
-- go

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

-- exec usp_gasto_periodo @FechaInicio = '2023-01-01',  @FechaFin = '2025-06-05';
-- go

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

-- exec usp_gasto_anual_por_producto;
-- go

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

-- exec usp_gasto_por_proveedor;
-- exec usp_gasto_por_proveedor @IdProveedor = 37; -- Tambo Don Juan
-- go

