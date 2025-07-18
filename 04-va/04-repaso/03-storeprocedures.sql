create procedure usp_cantidad_usuarios_por_sector_2
as
begin
	select *
	from Sector s
end
go

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

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

	select s.IdSector, s.Nombre, count(distinct sub.IdUsuario) as CantidadUsuarios
	from Sector s left join
	(   select pos.IdSector,
				u.Idusuario
		from PermisoOrdenSector pos
		join Permiso p on p.IdPermiso = pos.IdPermiso
		join RolPermiso rp on rp.IdPermiso = p.IdPermiso
		join Rol r on r.IdRol = rp.IdRol
		join UsuarioRol ur on ur.IdRol = r.IdRol
		join Usuario u on u.IdUsuario = ur.IdUsuario
	) as sub on sub.IdSector = s.IdSector
		group by s.IdSector, s.Nombre
		order by s.Nombre
	




select top 1 * from PermisoOrdenSector order by newid()