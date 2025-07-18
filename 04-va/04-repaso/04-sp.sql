create or alter procedure usp_usuario_pertenecen_a_sector_2
	@NombreSector nvarchar(100)
as
begin
	select distinct u.IdUsuario, u.Nombre
	from Usuario u
	join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
	join Rol r on r.IdRol = ur.IdRol
	join RolPermiso rp on rp.IdRol = r.IdRol
	join Permiso p on p.IdPermiso = rp.IdPermiso
	join PermisoOrdenSector pos on pos.IdPermiso = p.IdPermiso
	join Sector s on s.IdSector = pos.IdSector
	where s.Nombre = @NombreSector
	--group by u.IdUsuario, u.Nombre

end




exec usp_usuario_pertenecen_a_sector_2 'Dulceria'