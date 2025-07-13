

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
    order by d.Nombre;
end
go

create or alter procedure usp_stock_por_deposito
    @IdDeposito int
as
begin
    set nocount on;

    select *
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join Producto p on p.CodProducto = ms.CodProducto
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.IdDeposito = @IdDeposito
    group by d.IdDeposito, d.Nombre, p.CodProducto, p.Descripcion, um.Nombre
    order by p.Descripcion
end;
go
