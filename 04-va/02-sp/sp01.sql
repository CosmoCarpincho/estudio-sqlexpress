-- SP PRINCIPALES --

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
    









-- SP EXTRAS --

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


-- Lo mismo pero para sector_ordenes:
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




