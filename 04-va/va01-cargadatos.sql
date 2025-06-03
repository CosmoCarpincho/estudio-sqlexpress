-- RBAC
create procedure usp_insertar_permiso_orden_sector
    @Nombre nvarchar(100),
    @Descripcion nvarchar(255),
    @Accion varchar(10),
    @TipoOrden varchar(30),
    @IdSector int
as
begin
    set nocount on;

    begin transaction;

    begin try
        insert into Permiso (Nombre, Descripcion)
        values (@Nombre, @Descripcion);

        declare @NuevoId int = SCOPE_IDENTITY();

        insert into PermisoOrdenSector (IdPermiso, TipoOrden, IdSector, Accion)
        values (@NuevoId, @TipoOrden, @IdSector, @Accion);

        commit transaction;
    end try
    begin catch
        rollback transaction;

        throw;
    end catch
end
go

-- Sectores

insert into Sector (Nombre)
values
('Recibo'),
('Polvos'),
('Dulceria'),
('Nano y Concentrados');
go

-- Permisos Generales: 
insert into Permiso (Nombre, Descripcion)
values
('GestionarUsuarios', 'Crear, editar, borrar o ver usuarios del sistema'),
('GestionarRoles', 'Administrar los roles del sistema'),
('GestionarPermisos', 'Administrar los permisos generales y específicos'),
('AccederAuditoriaSistema', 'Ver logs de auditoría del sistema'),
('VerDashboardGeneral', 'Acceder al dashboard de indicadores globales'),
('AccederConfiguracionSistema', 'Ver o cambiar configuraciones generales del sistema'),
('VerBitacoraErroresSistema', 'Consultar logs de errores y fallas'),
('GestionarRespaldos', 'Hacer backup o restore de la base de datos'),
('ExportarReportes', 'Permitir exportar reportes del sistema'),
('GestionarNotificaciones', 'Administrar notificaciones y alertas del sistema');
go

declare @IdRecibo int;
declare @IdPolvos int;
declare @IdDulceria int;
declare @IdNanoYConcentrados int;

select @IdRecibo = IdSector from Sector where Nombre = 'Recibo';
select @IdPolvos = IdSector from Sector where Nombre = 'Polvos';
select @IdDulceria = IdSector from Sector where Nombre = 'Dulceria';
select @IdNanoYConcentrados = IdSector from Sector where Nombre = 'Nano y Concentrados';


-- Permisos de modelo de negocio -> PermisosOrdenSector
--exec usp_insertar_permiso_orden_sector 'Nombre', 'Descripcion', 'Accion', 'TipoOrden', @IdSector

-- Permisos para Recibo
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenFabricacion_Leer', 'Lectura de órdenes de fabricación en recibo', 'Leer', 'OrdenFabricacion', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenFabricacion_Crear', 'Creación de órdenes de fabricación en recibo', 'Crear', 'OrdenFabricacion', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenFabricacion_Editar', 'Edición de órdenes de fabricación en recibo', 'Editar', 'OrdenFabricacion', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenFabricacion_Borrar', 'Borrado de órdenes de fabricación en recibo', 'Borrar', 'OrdenFabricacion', @IdRecibo;

exec usp_insertar_permiso_orden_sector 'Recibo_OrdenEntrega_Leer', 'Lectura de órdenes de entrega en recibo', 'Leer', 'OrdenEntrega', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenEntrega_Crear', 'Creación de órdenes de entrega en recibo', 'Crear', 'OrdenEntrega', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenEntrega_Editar', 'Edición de órdenes de entrega en recibo', 'Editar', 'OrdenEntrega', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenEntrega_Borrar', 'Borrado de órdenes de entrega en recibo', 'Borrar', 'OrdenEntrega', @IdRecibo;

-- exec usp_insertar_permiso_orden_sector 'Recibo_OrdenCompra_Leer', 'Lectura de órdenes de compra en recibo', 'Leer', 'OrdenCompra', @IdRecibo;
-- exec usp_insertar_permiso_orden_sector 'Recibo_OrdenCompra_Crear', 'Creación de órdenes de compra en recibo', 'Crear', 'OrdenCompra', @IdRecibo;
-- exec usp_insertar_permiso_orden_sector 'Recibo_OrdenCompra_Editar', 'Edición de órdenes de compra en recibo', 'Editar', 'OrdenCompra', @IdRecibo;
-- exec usp_insertar_permiso_orden_sector 'Recibo_OrdenCompra_Borrar', 'Borrado de órdenes de compra en recibo', 'Borrar', 'OrdenCompra', @IdRecibo;

exec usp_insertar_permiso_orden_sector 'Recibo_OrdenReposicion_Leer', 'Lectura de órdenes de reposición en recibo', 'Leer', 'OrdenReposicion', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenReposicion_Crear', 'Creación de órdenes de reposición en recibo', 'Crear', 'OrdenReposicion', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenReposicion_Editar', 'Edición de órdenes de reposición en recibo', 'Editar', 'OrdenReposicion', @IdRecibo;
exec usp_insertar_permiso_orden_sector 'Recibo_OrdenReposicion_Borrar', 'Borrado de órdenes de reposición en recibo', 'Borrar', 'OrdenReposicion', @IdRecibo;

-- Permisos para Polvos
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenFabricacion_Leer', 'Lectura de órdenes de fabricación en polvos', 'Leer', 'OrdenFabricacion', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenFabricacion_Crear', 'Creación de órdenes de fabricación en polvos', 'Crear', 'OrdenFabricacion', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenFabricacion_Editar', 'Edición de órdenes de fabricación en polvos', 'Editar', 'OrdenFabricacion', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenFabricacion_Borrar', 'Borrado de órdenes de fabricación en polvos', 'Borrar', 'OrdenFabricacion', @IdPolvos;

exec usp_insertar_permiso_orden_sector 'Polvos_OrdenEntrega_Leer', 'Lectura de órdenes de entrega en polvos', 'Leer', 'OrdenEntrega', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenEntrega_Crear', 'Creación de órdenes de entrega en polvos', 'Crear', 'OrdenEntrega', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenEntrega_Editar', 'Edición de órdenes de entrega en polvos', 'Editar', 'OrdenEntrega', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenEntrega_Borrar', 'Borrado de órdenes de entrega en polvos', 'Borrar', 'OrdenEntrega', @IdPolvos;

-- exec usp_insertar_permiso_orden_sector 'Polvos_OrdenCompra_Leer', 'Lectura de órdenes de compra en polvos', 'Leer', 'OrdenCompra', @IdPolvos;
-- exec usp_insertar_permiso_orden_sector 'Polvos_OrdenCompra_Crear', 'Creación de órdenes de compra en polvos', 'Crear', 'OrdenCompra', @IdPolvos;
-- exec usp_insertar_permiso_orden_sector 'Polvos_OrdenCompra_Editar', 'Edición de órdenes de compra en polvos', 'Editar', 'OrdenCompra', @IdPolvos;
-- exec usp_insertar_permiso_orden_sector 'Polvos_OrdenCompra_Borrar', 'Borrado de órdenes de compra en polvos', 'Borrar', 'OrdenCompra', @IdPolvos;

exec usp_insertar_permiso_orden_sector 'Polvos_OrdenReposicion_Leer', 'Lectura de órdenes de reposición en polvos', 'Leer', 'OrdenReposicion', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenReposicion_Crear', 'Creación de órdenes de reposición en polvos', 'Crear', 'OrdenReposicion', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenReposicion_Editar', 'Edición de órdenes de reposición en polvos', 'Editar', 'OrdenReposicion', @IdPolvos;
exec usp_insertar_permiso_orden_sector 'Polvos_OrdenReposicion_Borrar', 'Borrado de órdenes de reposición en polvos', 'Borrar', 'OrdenReposicion', @IdPolvos;

-- Permisos para Dulceria
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenFabricacion_Leer', 'Lectura de órdenes de fabricación en dulcería', 'Leer', 'OrdenFabricacion', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenFabricacion_Crear', 'Creación de órdenes de fabricación en dulcería', 'Crear', 'OrdenFabricacion', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenFabricacion_Editar', 'Edición de órdenes de fabricación en dulcería', 'Editar', 'OrdenFabricacion', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenFabricacion_Borrar', 'Borrado de órdenes de fabricación en dulcería', 'Borrar', 'OrdenFabricacion', @IdDulceria;

exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenEntrega_Leer', 'Lectura de órdenes de entrega en dulcería', 'Leer', 'OrdenEntrega', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenEntrega_Crear', 'Creación de órdenes de entrega en dulcería', 'Crear', 'OrdenEntrega', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenEntrega_Editar', 'Edición de órdenes de entrega en dulcería', 'Editar', 'OrdenEntrega', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenEntrega_Borrar', 'Borrado de órdenes de entrega en dulcería', 'Borrar', 'OrdenEntrega', @IdDulceria;

-- exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenCompra_Leer', 'Lectura de órdenes de compra en dulcería', 'Leer', 'OrdenCompra', @IdDulceria;
-- exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenCompra_Crear', 'Creación de órdenes de compra en dulcería', 'Crear', 'OrdenCompra', @IdDulceria;
-- exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenCompra_Editar', 'Edición de órdenes de compra en dulcería', 'Editar', 'OrdenCompra', @IdDulceria;
-- exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenCompra_Borrar', 'Borrado de órdenes de compra en dulcería', 'Borrar', 'OrdenCompra', @IdDulceria;

exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenReposicion_Leer', 'Lectura de órdenes de reposición en dulcería', 'Leer', 'OrdenReposicion', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenReposicion_Crear', 'Creación de órdenes de reposición en dulcería', 'Crear', 'OrdenReposicion', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenReposicion_Editar', 'Edición de órdenes de reposición en dulcería', 'Editar', 'OrdenReposicion', @IdDulceria;
exec usp_insertar_permiso_orden_sector 'Dulceria_OrdenReposicion_Borrar', 'Borrado de órdenes de reposición en dulcería', 'Borrar', 'OrdenReposicion', @IdDulceria;

-- Permisos para Nano y Concentrados
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenFabricacion_Leer', 'Lectura de órdenes de fabricación en nano y concentrados', 'Leer', 'OrdenFabricacion', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenFabricacion_Crear', 'Creación de órdenes de fabricación en nano y concentrados', 'Crear', 'OrdenFabricacion', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenFabricacion_Editar', 'Edición de órdenes de fabricación en nano y concentrados', 'Editar', 'OrdenFabricacion', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenFabricacion_Borrar', 'Borrado de órdenes de fabricación en nano y concentrados', 'Borrar', 'OrdenFabricacion', @IdNanoYConcentrados;

exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenEntrega_Leer', 'Lectura de órdenes de entrega en nano y concentrados', 'Leer', 'OrdenEntrega', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenEntrega_Crear', 'Creación de órdenes de entrega en nano y concentrados', 'Crear', 'OrdenEntrega', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenEntrega_Editar', 'Edición de órdenes de entrega en nano y concentrados', 'Editar', 'OrdenEntrega', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenEntrega_Borrar', 'Borrado de órdenes de entrega en nano y concentrados', 'Borrar', 'OrdenEntrega', @IdNanoYConcentrados;

-- exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenCompra_Leer', 'Lectura de órdenes de compra en nano y concentrados', 'Leer', 'OrdenCompra', @IdNanoYConcentrados;
-- exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenCompra_Crear', 'Creación de órdenes de compra en nano y concentrados', 'Crear', 'OrdenCompra', @IdNanoYConcentrados;
-- exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenCompra_Editar', 'Edición de órdenes de compra en nano y concentrados', 'Editar', 'OrdenCompra', @IdNanoYConcentrados;
-- exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenCompra_Borrar', 'Borrado de órdenes de compra en nano y concentrados', 'Borrar', 'OrdenCompra', @IdNanoYConcentrados;

exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenReposicion_Leer', 'Lectura de órdenes de reposición en nano y concentrados', 'Leer', 'OrdenReposicion', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenReposicion_Crear', 'Creación de órdenes de reposición en nano y concentrados', 'Crear', 'OrdenReposicion', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenReposicion_Editar', 'Edición de órdenes de reposición en nano y concentrados', 'Editar', 'OrdenReposicion', @IdNanoYConcentrados;
exec usp_insertar_permiso_orden_sector 'NanoYConcentrados_OrdenReposicion_Borrar', 'Borrado de órdenes de reposición en nano y concentrados', 'Borrar', 'OrdenReposicion', @IdNanoYConcentrados;

go


-- Permisos de ordenes de compra
insert into Permiso (Nombre, Descripcion)
values 
('OrdenCompra_Leer', 'Permite leer órdenes de compra'),
('OrdenCompra_Crear', 'Permite crear órdenes de compra'),
('OrdenCompra_Editar', 'Permite editar órdenes de compra'),
('OrdenCompra_Borrar', 'Permite borrar órdenes de compra');
go

-- Roles

create or alter procedure usp_crear_rol_permisos
    @NombreRol nvarchar(100),
    @DescripcionRol nvarchar(255),
    @Permisos nvarchar(max)  -- ej: 'Dulceria_OrdenReposicion_Leer,Dulceria_OrdenReposicion_Leer'
as
begin
    set nocount on;
    begin try
        begin transaction;

        -- Validar que el rol no exista
        if exists (select 1 from Rol where Nombre = @NombreRol)
        begin
            raiserror('Ya existe un rol con el nombre "%s".', 16, 1, @NombreRol);
            rollback transaction;
            return;
        end

        -- Crear tabla temporal para guardar los permisos solicitados
        declare @PermisosSolicitados table (Nombre nvarchar(100));
        insert into @PermisosSolicitados (Nombre)
        select ltrim(rtrim(value))
        from string_split(@Permisos, ',');

        -- Verificar si hay permisos inexistentes
        declare @PermisosInvalidos table (Nombre nvarchar(100));
        insert into @PermisosInvalidos (Nombre)
        select ps.Nombre
        from @PermisosSolicitados ps
        left join Permiso p on ps.Nombre = p.Nombre
        where p.IdPermiso is null;

        if exists (select 1 from @PermisosInvalidos)
        begin
            raiserror('Uno o más permisos no existen.', 16, 1);
            select Nombre as PermisoNoEncontrado from @PermisosInvalidos;
            rollback transaction;
            return;
        end

        -- Insertar el nuevo rol
        insert into Rol (Nombre, Descripcion)
        values (@NombreRol, @DescripcionRol);

        declare @IdRol int = scope_identity();

        -- Asociar permisos al nuevo rol
        insert into RolPermiso (IdRol, IdPermiso)
        select @IdRol, p.IdPermiso
        from Permiso p
        join @PermisosSolicitados ps on p.Nombre = ps.Nombre;

        commit transaction;

        -- Devolver el Id del rol creado
        select @IdRol as IdRolCreado;

    end try
    begin catch
        if @@trancount > 0 rollback transaction;

        -- Reenviar el error
        throw;
    end catch
end
go


-- ej: exec usp_crear_rol_permisos 'SupervisorRecibo', 'Acceso de lectura y edición a órdenes de recibo', 'Recibo_OrdenFabricacion_Leer,Recibo_OrdenFabricacion_Editar,Recibo_OrdenEntrega_Leer';


-- ADMIN
exec usp_crear_rol_permisos 
    @NombreRol = 'Admin',
    @DescripcionRol = 'Rol administrativo con acceso total a todas las funcionalidades del sistema',
    @Permisos = 'Recibo_OrdenFabricacion_Leer,Recibo_OrdenFabricacion_Crear,Recibo_OrdenFabricacion_Editar,Recibo_OrdenFabricacion_Borrar,Recibo_OrdenEntrega_Leer,Recibo_OrdenEntrega_Crear,Recibo_OrdenEntrega_Editar,Recibo_OrdenEntrega_Borrar,Recibo_OrdenReposicion_Leer,Recibo_OrdenReposicion_Crear,Recibo_OrdenReposicion_Editar,Recibo_OrdenReposicion_Borrar,Polvos_OrdenFabricacion_Leer,Polvos_OrdenFabricacion_Crear,Polvos_OrdenFabricacion_Editar,Polvos_OrdenFabricacion_Borrar,Polvos_OrdenEntrega_Leer,Polvos_OrdenEntrega_Crear,Polvos_OrdenEntrega_Editar,Polvos_OrdenEntrega_Borrar,Polvos_OrdenReposicion_Leer,Polvos_OrdenReposicion_Crear,Polvos_OrdenReposicion_Editar,Polvos_OrdenReposicion_Borrar,Dulceria_OrdenFabricacion_Leer,Dulceria_OrdenFabricacion_Crear,Dulceria_OrdenFabricacion_Editar,Dulceria_OrdenFabricacion_Borrar,Dulceria_OrdenEntrega_Leer,Dulceria_OrdenEntrega_Crear,Dulceria_OrdenEntrega_Editar,Dulceria_OrdenEntrega_Borrar,Dulceria_OrdenReposicion_Leer,Dulceria_OrdenReposicion_Crear,Dulceria_OrdenReposicion_Editar,Dulceria_OrdenReposicion_Borrar,NanoYConcentrados_OrdenFabricacion_Leer,NanoYConcentrados_OrdenFabricacion_Crear,NanoYConcentrados_OrdenFabricacion_Editar,NanoYConcentrados_OrdenFabricacion_Borrar,NanoYConcentrados_OrdenEntrega_Leer,NanoYConcentrados_OrdenEntrega_Crear,NanoYConcentrados_OrdenEntrega_Editar,NanoYConcentrados_OrdenEntrega_Borrar,NanoYConcentrados_OrdenReposicion_Leer,NanoYConcentrados_OrdenReposicion_Crear,NanoYConcentrados_OrdenReposicion_Editar,NanoYConcentrados_OrdenReposicion_Borrar,OrdenCompra_Leer,OrdenCompra_Crear,OrdenCompra_Editar,OrdenCompra_Borrar'
;
go

-- ==== SECTOR: Recibo ====

-- OperarioRecibo
exec usp_crear_rol_permisos 
    @NombreRol = 'OperarioRecibo', 
    @DescripcionRol = 'Puede leer todas las órdenes y crear órdenes de fabricación en Recibo, sin permisos de edición ni borrado', 
    @Permisos = 'Recibo_OrdenFabricacion_Leer,Recibo_OrdenFabricacion_Crear,Recibo_OrdenEntrega_Leer,Recibo_OrdenReposicion_Leer';

-- SupervisorRecibo
exec usp_crear_rol_permisos 
    @NombreRol = 'SupervisorRecibo', 
    @DescripcionRol = 'Acceso de lectura, creación y edición a todas las órdenes en Recibo', 
    @Permisos = 'Recibo_OrdenFabricacion_Leer,Recibo_OrdenFabricacion_Crear,Recibo_OrdenFabricacion_Editar,Recibo_OrdenEntrega_Leer,Recibo_OrdenEntrega_Editar,Recibo_OrdenReposicion_Leer,Recibo_OrdenReposicion_Editar';

-- JefeRecibo
exec usp_crear_rol_permisos 
    @NombreRol = 'JefeRecibo', 
    @DescripcionRol = 'Acceso total a lectura, creación y edición de órdenes en Recibo', 
    @Permisos = 'Recibo_OrdenFabricacion_Leer,Recibo_OrdenFabricacion_Crear,Recibo_OrdenFabricacion_Editar,Recibo_OrdenEntrega_Leer,Recibo_OrdenEntrega_Editar,Recibo_OrdenReposicion_Leer,Recibo_OrdenReposicion_Editar';

-- AnalistaRecibo
exec usp_crear_rol_permisos 
    @NombreRol = 'AnalistaRecibo', 
    @DescripcionRol = 'Puede leer y editar órdenes en Recibo, sin permiso de creación ni borrado', 
    @Permisos = 'Recibo_OrdenFabricacion_Leer,Recibo_OrdenFabricacion_Editar,Recibo_OrdenEntrega_Leer,Recibo_OrdenEntrega_Editar,Recibo_OrdenReposicion_Leer,Recibo_OrdenReposicion_Editar';

-- ==== SECTOR: Polvos ====

-- OperarioPolvos
exec usp_crear_rol_permisos 
    @NombreRol = 'OperarioPolvos', 
    @DescripcionRol = 'Puede leer todas las órdenes y crear órdenes de fabricación en Polvos, sin permisos de edición ni borrado', 
    @Permisos = 'Polvos_OrdenFabricacion_Leer,Polvos_OrdenFabricacion_Crear,Polvos_OrdenEntrega_Leer,Polvos_OrdenReposicion_Leer';

-- SupervisorPolvos
exec usp_crear_rol_permisos 
    @NombreRol = 'SupervisorPolvos', 
    @DescripcionRol = 'Acceso de lectura, creación y edición a todas las órdenes en Polvos', 
    @Permisos = 'Polvos_OrdenFabricacion_Leer,Polvos_OrdenFabricacion_Crear,Polvos_OrdenFabricacion_Editar,Polvos_OrdenEntrega_Leer,Polvos_OrdenEntrega_Editar,Polvos_OrdenReposicion_Leer,Polvos_OrdenReposicion_Editar';

-- JefePolvos
exec usp_crear_rol_permisos 
    @NombreRol = 'JefePolvos', 
    @DescripcionRol = 'Acceso total a lectura, creación y edición de órdenes en Polvos', 
    @Permisos = 'Polvos_OrdenFabricacion_Leer,Polvos_OrdenFabricacion_Crear,Polvos_OrdenFabricacion_Editar,Polvos_OrdenEntrega_Leer,Polvos_OrdenEntrega_Editar,Polvos_OrdenReposicion_Leer,Polvos_OrdenReposicion_Editar';

-- AnalistaPolvos
exec usp_crear_rol_permisos 
    @NombreRol = 'AnalistaPolvos', 
    @DescripcionRol = 'Puede leer y editar órdenes en Polvos, sin permiso de creación ni borrado', 
    @Permisos = 'Polvos_OrdenFabricacion_Leer,Polvos_OrdenFabricacion_Editar,Polvos_OrdenEntrega_Leer,Polvos_OrdenEntrega_Editar,Polvos_OrdenReposicion_Leer,Polvos_OrdenReposicion_Editar';

-- ==== SECTOR: Dulceria ====

-- OperarioDulceria
exec usp_crear_rol_permisos 
    @NombreRol = 'OperarioDulceria', 
    @DescripcionRol = 'Puede leer todas las órdenes y crear órdenes de fabricación en Dulcería, sin permisos de edición ni borrado', 
    @Permisos = 'Dulceria_OrdenFabricacion_Leer,Dulceria_OrdenFabricacion_Crear,Dulceria_OrdenEntrega_Leer,Dulceria_OrdenReposicion_Leer';

-- SupervisorDulceria
exec usp_crear_rol_permisos 
    @NombreRol = 'SupervisorDulceria', 
    @DescripcionRol = 'Acceso de lectura, creación y edición a todas las órdenes en Dulcería', 
    @Permisos = 'Dulceria_OrdenFabricacion_Leer,Dulceria_OrdenFabricacion_Crear,Dulceria_OrdenFabricacion_Editar,Dulceria_OrdenEntrega_Leer,Dulceria_OrdenEntrega_Editar,Dulceria_OrdenReposicion_Leer,Dulceria_OrdenReposicion_Editar';

-- JefeDulceria
exec usp_crear_rol_permisos 
    @NombreRol = 'JefeDulceria', 
    @DescripcionRol = 'Acceso total a lectura, creación y edición de órdenes en Dulcería', 
    @Permisos = 'Dulceria_OrdenFabricacion_Leer,Dulceria_OrdenFabricacion_Crear,Dulceria_OrdenFabricacion_Editar,Dulceria_OrdenEntrega_Leer,Dulceria_OrdenEntrega_Editar,Dulceria_OrdenReposicion_Leer,Dulceria_OrdenReposicion_Editar';

-- AnalistaDulceria
exec usp_crear_rol_permisos 
    @NombreRol = 'AnalistaDulceria', 
    @DescripcionRol = 'Puede leer y editar órdenes en Dulcería, sin permiso de creación ni borrado', 
    @Permisos = 'Dulceria_OrdenFabricacion_Leer,Dulceria_OrdenFabricacion_Editar,Dulceria_OrdenEntrega_Leer,Dulceria_OrdenEntrega_Editar,Dulceria_OrdenReposicion_Leer,Dulceria_OrdenReposicion_Editar';

-- ==== SECTOR: NanoYConcentrados ====

-- OperarioNanoYConcentrados
exec usp_crear_rol_permisos 
    @NombreRol = 'OperarioNanoYConcentrados', 
    @DescripcionRol = 'Puede leer todas las órdenes y crear órdenes de fabricación en Nano y Concentrados, sin permisos de edición ni borrado', 
    @Permisos = 'NanoYConcentrados_OrdenFabricacion_Leer,NanoYConcentrados_OrdenFabricacion_Crear,NanoYConcentrados_OrdenEntrega_Leer,NanoYConcentrados_OrdenReposicion_Leer';

-- SupervisorNanoYConcentrados
exec usp_crear_rol_permisos 
    @NombreRol = 'SupervisorNanoYConcentrados', 
    @DescripcionRol = 'Acceso de lectura, creación y edición a todas las órdenes en Nano y Concentrados', 
    @Permisos = 'NanoYConcentrados_OrdenFabricacion_Leer,NanoYConcentrados_OrdenFabricacion_Crear,NanoYConcentrados_OrdenFabricacion_Editar,NanoYConcentrados_OrdenEntrega_Leer,NanoYConcentrados_OrdenEntrega_Editar,NanoYConcentrados_OrdenReposicion_Leer,NanoYConcentrados_OrdenReposicion_Editar';

-- JefeNanoYConcentrados
exec usp_crear_rol_permisos 
    @NombreRol = 'JefeNanoYConcentrados', 
    @DescripcionRol = 'Acceso total a lectura, creación y edición de órdenes en Nano y Concentrados', 
    @Permisos = 'NanoYConcentrados_OrdenFabricacion_Leer,NanoYConcentrados_OrdenFabricacion_Crear,NanoYConcentrados_OrdenFabricacion_Editar,NanoYConcentrados_OrdenEntrega_Leer,NanoYConcentrados_OrdenEntrega_Editar,NanoYConcentrados_OrdenReposicion_Leer,NanoYConcentrados_OrdenReposicion_Editar';

-- AnalistaNanoYConcentrados
exec usp_crear_rol_permisos 
    @NombreRol = 'AnalistaNanoYConcentrados', 
    @DescripcionRol = 'Puede leer y editar órdenes en Nano y Concentrados, sin permiso de creación ni borrado', 
    @Permisos = 'NanoYConcentrados_OrdenFabricacion_Leer,NanoYConcentrados_OrdenFabricacion_Editar,NanoYConcentrados_OrdenEntrega_Leer,NanoYConcentrados_OrdenEntrega_Editar,NanoYConcentrados_OrdenReposicion_Leer,NanoYConcentrados_OrdenReposicion_Editar';
go


-- CREAR USUARIOS CON ROLES ASIGNADOS --

create procedure usp_crear_usuario_con_rol
    @Clave nvarchar(100),
    @Nombre nvarchar(50),
    @Apellido nvarchar(50),
    @Email nvarchar(254),
    @NombreRol nvarchar(100)
as
begin
    set nocount on;

    begin try
        begin transaction;

        -- Verificamos que no exista el email
        if exists (select 1 from Usuario where Email = @Email)
        begin
            raiserror('Ya existe un usuario con ese email.', 16, 1);
            rollback transaction;
            return;
        end

        -- Obtenemos el Id del Rol
        declare @IdRol int;
        select @IdRol = IdRol from Rol where Nombre = @NombreRol;

        if @IdRol is null
        begin
            raiserror('El rol especificado no existe.', 16, 1);
            rollback transaction;
            return;
        end

        -- Insertamos el usuario
        declare @IdUsuario int;
        insert into Usuario (Clave, Nombre, Apellido, Email)
        values (@Clave, @Nombre, @Apellido, @Email);

        set @IdUsuario = scope_identity();

        -- Asignamos el rol
        insert into UsuarioRol (IdUsuario, IdRol)
        values (@IdUsuario, @IdRol);

        commit transaction;
    end try
    begin catch
        if @@trancount > 0 rollback transaction;

        declare @ErrMsg nvarchar(4000) = error_message();
        declare @ErrSeverity int = error_severity();
        declare @ErrState int = error_state();
        raiserror(@ErrMsg, @ErrSeverity, @ErrState);
    end catch
end
go

-- ADMIN
-- Vamos a insertar que sea a la fuerza el identificador 1
--exec usp_crear_usuario_con_rol @Clave = 'Admin123', @Nombre = 'Pepe', @Apellido = 'Argento', @Email = 'pepe.argento@gmail.com', @NombreRol = 'Admin';
set identity_insert Usuario on;

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (1, 'Admin123', 'Pepe', 'Argento', 'pepe.argento@gmail.com');

set identity_insert Usuario off;

insert into UsuarioRol (IdUsuario, IdRol)
select 1, IdRol from Rol where Nombre = 'Admin'


-- Recibo
exec usp_crear_usuario_con_rol @Clave = 'Jp3r3z#2025', @Nombre = 'Juan', @Apellido = 'Pérez', @Email = 'juan.perez1@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'AnGm_84$', @Nombre = 'Ana', @Apellido = 'Gómez', @Email = 'ana.gomez@ejemplo.com', @NombreRol = 'SupervisorRecibo';
exec usp_crear_usuario_con_rol @Clave = 'CrlzL0p!', @Nombre = 'Carlos', @Apellido = 'López', @Email = 'carlos.lopez@ejemplo.com', @NombreRol = 'JefeRecibo';
exec usp_crear_usuario_con_rol @Clave = 'L@uMart2024', @Nombre = 'Laura', @Apellido = 'Martínez', @Email = 'laura.martinez@ejemplo.com', @NombreRol = 'AnalistaRecibo';
exec usp_crear_usuario_con_rol @Clave = 'TmsAln_92!', @Nombre = 'Tomás', @Apellido = 'Alonso', @Email = 'tomas.alonso@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'M4rt1na.Pz', @Nombre = 'Martina', @Apellido = 'Paz', @Email = 'martina.paz@ejemplo.com', @NombreRol = 'SupervisorRecibo';
exec usp_crear_usuario_con_rol @Clave = 'D13g0Cruz!', @Nombre = 'Diego', @Apellido = 'Cruz', @Email = 'diego.cruz@ejemplo.com', @NombreRol = 'JefeRecibo';
exec usp_crear_usuario_con_rol @Clave = 'AgstIbr#22', @Nombre = 'Agustina', @Apellido = 'Ibarra', @Email = 'agustina.ibarra@ejemplo.com', @NombreRol = 'AnalistaRecibo';
exec usp_crear_usuario_con_rol @Clave = 'H3rnBr4v@', @Nombre = 'Hernán', @Apellido = 'Bravo', @Email = 'hernan.bravo@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'FlorF3rr_', @Nombre = 'Florencia', @Apellido = 'Ferreyra', @Email = 'florencia.ferreyra@ejemplo.com', @NombreRol = 'AnalistaRecibo';
exec usp_crear_usuario_con_rol @Clave = 'IV_40!25', @Nombre = 'Ivana', @Apellido = 'Vera', @Email = 'ivana.vera@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'MP_56!25', @Nombre = 'Marcos', @Apellido = 'Peralta', @Email = 'marcos.peralta@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'JS_72!25', @Nombre = 'Joaquín', @Apellido = 'Silveyra', @Email = 'joaquin.silveyra@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'CC_49!25', @Nombre = 'Carla', @Apellido = 'Quiñones', @Email = 'carla.quinones@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'FG_64!25', @Nombre = 'Federico', @Apellido = 'Gaitán', @Email = 'federico.gaitan@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'CO_56!25', @Nombre = 'Camilo', @Apellido = 'Olmedo', @Email = 'camilo.olmedo@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'SP_56!25', @Nombre = 'Selena', @Apellido = 'Palacios', @Email = 'selena.palacios@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'OI_64!25', @Nombre = 'Oscar', @Apellido = 'Iglesias', @Email = 'oscar.iglesias@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'PL_60!25', @Nombre = 'Paula', @Apellido = 'Leiva', @Email = 'paula.leiva@ejemplo.com', @NombreRol = 'OperarioRecibo';
exec usp_crear_usuario_con_rol @Clave = 'RS_63!25', @Nombre = 'Ramiro', @Apellido = 'Suárez', @Email = 'ramiro.suarez@ejemplo.com', @NombreRol = 'OperarioRecibo';


-- Polvos
exec usp_crear_usuario_con_rol @Clave = 'P3drS0s$', @Nombre = 'Pedro', @Apellido = 'Sosa', @Email = 'pedro.sosa@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'Lucia_R10s', @Nombre = 'Lucía', @Apellido = 'Ríos', @Email = 'lucia.rios@ejemplo.com', @NombreRol = 'SupervisorPolvos';
exec usp_crear_usuario_con_rol @Clave = 'Rmndz_!23', @Nombre = 'Ricardo', @Apellido = 'Méndez', @Email = 'ricardo.mendez@ejemplo.com', @NombreRol = 'JefePolvos';
exec usp_crear_usuario_con_rol @Clave = 'SfCabral*9', @Nombre = 'Sofía', @Apellido = 'Cabral', @Email = 'sofia.cabral@ejemplo.com', @NombreRol = 'AnalistaPolvos';
exec usp_crear_usuario_con_rol @Clave = 'Brn0Rey_20', @Nombre = 'Bruno', @Apellido = 'Rey', @Email = 'bruno.rey@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'DnlAcs_86', @Nombre = 'Daniela', @Apellido = 'Acosta', @Email = 'daniela.acosta@ejemplo.com', @NombreRol = 'SupervisorPolvos';
exec usp_crear_usuario_con_rol @Clave = 'SbstHrr@!', @Nombre = 'Sebastián', @Apellido = 'Herrera', @Email = 'sebastian.herrera@ejemplo.com', @NombreRol = 'JefePolvos';
exec usp_crear_usuario_con_rol @Clave = 'C4mR@mos.', @Nombre = 'Camila', @Apellido = 'Ramos', @Email = 'camila.ramos@ejemplo.com', @NombreRol = 'AnalistaPolvos';
exec usp_crear_usuario_con_rol @Clave = 'LuzDgldo_1', @Nombre = 'Luz', @Apellido = 'Delgado', @Email = 'luz.delgado@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'HgZmr.12!', @Nombre = 'Hugo', @Apellido = 'Zamora', @Email = 'hugo.zamora@ejemplo.com', @NombreRol = 'AnalistaPolvos';
exec usp_crear_usuario_con_rol @Clave = 'AxelR2025$', @Nombre = 'Axel', @Apellido = 'Roldán', @Email = 'axel.roldan@ejemplo.com', @NombreRol = 'JefePolvos';
exec usp_crear_usuario_con_rol @Clave = 'BO_56!25', @Nombre = 'Benjamín', @Apellido = 'Ojeda', @Email = 'benjamin.ojeda@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'LM_56!25', @Nombre = 'Lautaro', @Apellido = 'Moreno', @Email = 'lautaro.moreno@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'MF_56!25', @Nombre = 'Micaela', @Apellido = 'Frías', @Email = 'micaela.frias@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'LB_56!25', @Nombre = 'Lorenzo', @Apellido = 'Barrios', @Email = 'lorenzo.barrios@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'GA_49!25', @Nombre = 'Gabriela', @Apellido = 'Almada', @Email = 'gabriela.almada@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'MF_49!25', @Nombre = 'Manuel', @Apellido = 'Funes', @Email = 'manuel.funes@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'AT_56!25', @Nombre = 'Aldana', @Apellido = 'Toledo', @Email = 'aldana.toledo@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'RN_63!25', @Nombre = 'Renzo', @Apellido = 'Navarro', @Email = 'renzo.navarro@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'AM_64!25', @Nombre = 'Ailén', @Apellido = 'Moreira', @Email = 'ailen.moreira@ejemplo.com', @NombreRol = 'OperarioPolvos';
exec usp_crear_usuario_con_rol @Clave = 'DE_64!25', @Nombre = 'Delfina', @Apellido = 'Escobar', @Email = 'delfina.escobar@ejemplo.com', @NombreRol = 'OperarioPolvos';


-- Dulceria
exec usp_crear_usuario_con_rol @Clave = 'AndrsSlv@', @Nombre = 'Andrés', @Apellido = 'Silva', @Email = 'andres.silva@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'VlrLuna_77', @Nombre = 'Valeria', @Apellido = 'Luna', @Email = 'valeria.luna@ejemplo.com', @NombreRol = 'SupervisorDulceria';
exec usp_crear_usuario_con_rol @Clave = 'EstQrg9$', @Nombre = 'Esteban', @Apellido = 'Quiroga', @Email = 'esteban.quiroga@ejemplo.com', @NombreRol = 'JefeDulceria';
exec usp_crear_usuario_con_rol @Clave = 'M@Vega.12', @Nombre = 'María', @Apellido = 'Vega', @Email = 'maria.vega@ejemplo.com', @NombreRol = 'AnalistaDulceria';
exec usp_crear_usuario_con_rol @Clave = 'NclsArc3$', @Nombre = 'Nicolás', @Apellido = 'Arce', @Email = 'nicolas.arce@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'BrbrMdn_', @Nombre = 'Bárbara', @Apellido = 'Medina', @Email = 'barbara.medina@ejemplo.com', @NombreRol = 'SupervisorDulceria';
exec usp_crear_usuario_con_rol @Clave = 'FrncFg!2024', @Nombre = 'Franco', @Apellido = 'Figueroa', @Email = 'franco.figueroa@ejemplo.com', @NombreRol = 'JefeDulceria';
exec usp_crear_usuario_con_rol @Clave = 'JulNnz_97', @Nombre = 'Julieta', @Apellido = 'Núñez', @Email = 'julieta.nunez@ejemplo.com', @NombreRol = 'AnalistaDulceria';
exec usp_crear_usuario_con_rol @Clave = 'EmMuz@1!', @Nombre = 'Emanuel', @Apellido = 'Muñoz', @Email = 'emanuel.munoz@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'MelAyala$', @Nombre = 'Melina', @Apellido = 'Ayala', @Email = 'melina.ayala@ejemplo.com', @NombreRol = 'SupervisorDulceria';
exec usp_crear_usuario_con_rol @Clave = 'RmnSrrn_', @Nombre = 'Romina', @Apellido = 'Serrano', @Email = 'romina.serrano@ejemplo.com', @NombreRol = 'AnalistaDulceria';
exec usp_crear_usuario_con_rol @Clave = 'IV_40!25', @Nombre = 'Ivana', @Apellido = 'Vera', @Email = 'ivana.vera+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'MP_56!25', @Nombre = 'Marcos', @Apellido = 'Peralta', @Email = 'marcos.peralta+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'JS_72!25', @Nombre = 'Joaquín', @Apellido = 'Silveyra', @Email = 'joaquin.silveyra+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'FG_64!25', @Nombre = 'Federico', @Apellido = 'Gaitán', @Email = 'federico.gaitan+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'CO_56!25', @Nombre = 'Camilo', @Apellido = 'Olmedo', @Email = 'camilo.olmedo+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'OI_64!25', @Nombre = 'Oscar', @Apellido = 'Iglesias', @Email = 'oscar.iglesias+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
exec usp_crear_usuario_con_rol @Clave = 'RS_63!25', @Nombre = 'Ramiro', @Apellido = 'Suárez', @Email = 'ramiro.suarez+1@ejemplo.com', @NombreRol = 'OperarioDulceria';
go




-- Nano y Concentrados
exec usp_crear_usuario_con_rol @Clave = 'FlpOrt#2023', @Nombre = 'Felipe', @Apellido = 'Ortega', @Email = 'felipe.ortega@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'CcMorales_', @Nombre = 'Cecilia', @Apellido = 'Morales', @Email = 'cecilia.morales@ejemplo.com', @NombreRol = 'SupervisorNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'JvRmr_10!', @Nombre = 'Javier', @Apellido = 'Romero', @Email = 'javier.romero@ejemplo.com', @NombreRol = 'JefeNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'ElNavr#7', @Nombre = 'Elena', @Apellido = 'Navarro', @Email = 'elena.navarro@ejemplo.com', @NombreRol = 'AnalistaNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'GnzlLr4$', @Nombre = 'Gonzalo', @Apellido = 'Lara', @Email = 'gonzalo.lara@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'NoVdl_12', @Nombre = 'Noelia', @Apellido = 'Vidal', @Email = 'noelia.vidal@ejemplo.com', @NombreRol = 'SupervisorNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'IvBnTz_', @Nombre = 'Iván', @Apellido = 'Benítez', @Email = 'ivan.benitez@ejemplo.com', @NombreRol = 'JefeNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'PauMln_34', @Nombre = 'Paula', @Apellido = 'Molina', @Email = 'paula.molina@ejemplo.com', @NombreRol = 'AnalistaNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'TmrdPrd#1', @Nombre = 'Tamara', @Apellido = 'Paredes', @Email = 'tamara.paredes@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'AlnSnch!', @Nombre = 'Alan', @Apellido = 'Sánchez', @Email = 'alan.sanchez@ejemplo.com', @NombreRol = 'JefeNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'SP_56!25', @Nombre = 'Selena', @Apellido = 'Palacios', @Email = 'selena.palacios+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'PL_60!25', @Nombre = 'Paula', @Apellido = 'Leiva', @Email = 'paula.leiva+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'BO_56!25', @Nombre = 'Benjamín', @Apellido = 'Ojeda', @Email = 'benjamin.ojeda+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'MF_56!25', @Nombre = 'Micaela', @Apellido = 'Frías', @Email = 'micaela.frias+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'LB_56!25', @Nombre = 'Lorenzo', @Apellido = 'Barrios', @Email = 'lorenzo.barrios+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'GA_49!25', @Nombre = 'Gabriela', @Apellido = 'Almada', @Email = 'gabriela.almada+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';
exec usp_crear_usuario_con_rol @Clave = 'RN_63!25', @Nombre = 'Renzo', @Apellido = 'Navarro', @Email = 'renzo.navarro+1@ejemplo.com', @NombreRol = 'OperarioNanoYConcentrados';

go

-- NUEVO 

-- Insertar datos a entidades que no tienen FK



-- Estados --
-- EstadoOF
insert into EstadoOF (Nombre)
values ('Planificado'),('En Proceso'), ('Cerrado'), ('Calidad');
go

-- EstadoOC
insert into EstadoOC (Nombre)
values ('Solicitada'), ('Recibida');
go

-- EstadoOE
insert into EstadoOE (Nombre)
values ('Proceso'), ('Enviado'), ('Recibido');
go

-- EstadoOR
insert into EstadoOR (Nombre)
values ('Proceso'), ('Solicitado'), ('Cerrado');
go


-- Formula

-- UsuarioFormula
-- Como las formulas son muy importante solo tiene acceso el admin del sistema, administrador de formulas y 2 jefes en particular.


create procedure usp_insertar_formula_producto
    @DescripcionProducto nvarchar(255),
    @NombreFormula nvarchar(100),
    @DescripcionFormula nvarchar(255),
    @CodProductoSalida int output,
    @IdFormulaSalida int output
as
begin
    set nocount on;
    begin try
        begin transaction;

        -- Insertar Producto
        insert into Producto (Descripcion)
        values (@DescripcionProducto);

        set @CodProductoSalida = scope_identity();

        -- Insertar Formula
        insert into Formula (Nombre, Descripcion, CodProducto)
        values (@NombreFormula, @DescripcionFormula, @CodProductoSalida);

        set @IdFormulaSalida = scope_identity();

        commit transaction;
    end try
    begin catch
        if @@trancount > 0 rollback transaction;
        throw;
    end catch
end;
go

create procedure usp_relacionar_usuario_formula
    @IdUsuario int,
    @IdFormula int
as
begin
    set nocount on;

    begin try
        insert into UsuarioFormula (IdUsuario, IdFormula)
        values (@IdUsuario, @IdFormula);
    end try
    begin catch
        throw;
    end catch
end;
go

--GERALDINE
-- Algunos jefes que pueden interactuar con algunas formulas
declare 
    @IdUsuarioDulceria01 int,
    @IdUsuarioDulceria02 int,
    @IdUsuarioNYC int,
    @IdUsuarioPolvos int,
    @IdUsuarioRecibo int;

select @IdUsuarioDulceria01 = IdUsuario from Usuario where Email = 'esteban.quiroga@ejemplo.com';
select @IdUsuarioDulceria02 = IdUsuario from Usuario where Email = 'franco.figueroa@ejemplo.com';
select @IdUsuarioNYC = IdUsuario from Usuario where Email = 'ivan.benitez@ejemplo.com';
select @IdUsuarioPolvos = IdUsuario from Usuario where Email = 'axel.roldan@ejemplo.com';
select @IdUsuarioRecibo = IdUsuario from Usuario where Email = 'carlos.lopez@ejemplo.com';


declare @CodProducto int, @IdFormula int;

-- 1. Dulce de leche repostero industrial
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche repostero industrial',
    @NombreFormula = 'Fórmula DDL Repostero Alta Consistencia',
    @DescripcionFormula = 'Formula con alta proporción de sólidos totales, 70%, menor humedad, ideal para horneado y repostería.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula; -- el usuario 1 es el admin
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;


-- 2. Dulce de leche clásico para untar (marca blanca)
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar Marca Blanca',
    @NombreFormula = 'Fórmula DDL Untable Estándar 2025',
    @DescripcionFormula = 'Formula con textura suave, 62% sólidos, color caramelo claro, pensada para consumo directo.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria02, @IdFormula = @IdFormula;


-- 3. Dulce de leche para alfajores premium (exportación)
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche alfajor exportación',
    @NombreFormula = 'Fórmula Export Premium 75%',
    @DescripcionFormula = 'Alto contenido en sólidos (75%), color oscuro, sabor intenso, diseñado para exportación a Europa.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;


-- 4. Dulce de leche baja lactosa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche baja en lactosa',
    @NombreFormula = 'Fórmula DDL Lactosa Reducida',
    @DescripcionFormula = 'Tratamiento enzimático previo, menor contenido de lactosa (<0.5%), sabor tradicional conservado.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;

-- MAS:

-- 1. Leche en polvo entera
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo entera 26% grasa',
    @NombreFormula = 'Fórmula LPE 26 Alta Solubilidad',
    @DescripcionFormula = 'Secado spray, grasa 26%, diseñada para disolución instantánea en agua caliente o fría.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;


-- 2. Leche en polvo descremada
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo descremada <1% grasa',
    @NombreFormula = 'Fórmula LPD Ultra Light',
    @DescripcionFormula = 'Baja en grasa, alto contenido proteico, ideal para industria panificadora y alimentos infantiles.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;


-- Mas leches en polvo:
-- 1. Leche en polvo descremada Rastafari <1% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo descremada Rastafari <1% grasa',
    @NombreFormula = 'Fórmula LPD Rastafari Ultra Light',
    @DescripcionFormula = 'Baja en grasa, alto contenido proteico, ideal para panificación y alimentos infantiles.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 2. Leche en polvo entera Habanito 26% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo entera Habanito 26% grasa',
    @NombreFormula = 'Fórmula LPE Habanito Cremosa',
    @DescripcionFormula = 'Alta en grasa para un sabor cremoso y textura óptima en repostería.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 3. Leche en polvo descremada Capitán del Cosmo <1% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo descremada Capitán del Cosmo <1% grasa',
    @NombreFormula = 'Fórmula LPD Cosmo Ultra Light',
    @DescripcionFormula = 'Bajo en grasa, ideal para producción de alimentos infantiles y dietéticos.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 4. Leche en polvo entera La Porteña 25% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo entera La Porteña 25% grasa',
    @NombreFormula = 'Fórmula LPE Porteña Cremosa',
    @DescripcionFormula = 'Perfecta para uso en panadería y elaboración de alfajores con sabor intenso.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;

-- 5. Leche en polvo descremada El Correntino <0.5% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo descremada El Correntino <0.5% grasa',
    @NombreFormula = 'Fórmula LPD Correntino Light',
    @DescripcionFormula = 'Muy baja en grasa, alto contenido proteico para uso industrial y dietético.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 6. Leche en polvo entera La Ruca 27% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo entera La Ruca 27% grasa',
    @NombreFormula = 'Fórmula LPE Ruca Extra Cremosa',
    @DescripcionFormula = 'Alta cremosidad y sabor pleno, recomendada para rellenos y productos lácteos premium.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 7. Leche en polvo descremada La Chacarera <1% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo descremada La Chacarera <1% grasa',
    @NombreFormula = 'Fórmula LPD Chacarera Light',
    @DescripcionFormula = 'Baja en grasa con alta solubilidad, ideal para mezclas lácteas y dietas especiales.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 8. Leche en polvo entera El Gauchito 26% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo entera El Gauchito 26% grasa',
    @NombreFormula = 'Fórmula LPE Gauchito Cremosa',
    @DescripcionFormula = 'Para usos industriales que requieren alta calidad y sabor lácteo intenso.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;

-- 9. Leche en polvo descremada El Bombón <0.8% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo descremada El Bombón <0.8% grasa',
    @NombreFormula = 'Fórmula LPD Bombón Light',
    @DescripcionFormula = 'Producto con muy bajo contenido graso y buena solubilidad para bebidas lácteas.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;

-- 10. Leche en polvo entera La Abuela 25% grasa
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Leche en polvo entera La Abuela 25% grasa',
    @NombreFormula = 'Fórmula LPE Abuela Cremosa',
    @DescripcionFormula = 'Sabor tradicional y textura cremosa, óptima para elaboración de productos lácteos clásicos.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;


-- 3. Concentrado lácteo evaporado
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Concentrado lácteo evaporado 2x',
    @NombreFormula = 'Fórmula CL-Evaporado 2025',
    @DescripcionFormula = 'Concentración al 50% por evaporación, estabilizado para transporte a granel sin refrigeración.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;


-- 4. Concentrado proteico lácteo (CPL)
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Concentrado proteico lácteo 80%',
    @NombreFormula = 'Fórmula CPL-80 Microfiltrado',
    @DescripcionFormula = 'Separación por membrana, 80% proteínas, bajo contenido de lactosa, uso deportivo o nutricional.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioNYC, @IdFormula = @IdFormula;

-- Mas producto tipo dulce de leche para alfajores varios
-- 3. Dulce de leche clásico para untar Rastafari
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar Rastafari',
    @NombreFormula = 'Fórmula DDL Untable Rastafari 2025',
    @DescripcionFormula = 'Textura cremosa, 60% sólidos, color caramelo medio, ideal para untar en alfajores.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;

-- 4. Dulce de leche clásico para untar Habanito
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar Habanito',
    @NombreFormula = 'Fórmula DDL Untable Habanito 2025',
    @DescripcionFormula = 'Suave y dulce, 63% sólidos, color caramelo dorado, pensado para paladares exigentes.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria02, @IdFormula = @IdFormula;

-- 5. Dulce de leche clásico para untar Capitán del Cosmo
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar Capitán del Cosmo',
    @NombreFormula = 'Fórmula DDL Untable Cosmo 2025',
    @DescripcionFormula = 'Fórmula con cuerpo, 61% sólidos, color caramelo oscuro, ideal para untar o rellenar.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;

-- 6. Dulce de leche clásico para untar La Porteña
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar La Porteña',
    @NombreFormula = 'Fórmula DDL Untable Porteña 2025',
    @DescripcionFormula = 'Textura aterciopelada, 62% sólidos, color caramelo claro, para uso gourmet.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;

-- 7. Dulce de leche clásico para untar El Correntino
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar El Correntino',
    @NombreFormula = 'Fórmula DDL Untable Correntino 2025',
    @DescripcionFormula = 'Sabor tradicional, 60% sólidos, color caramelo medio, textura cremosa.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;

-- 8. Dulce de leche clásico para untar La Ruca
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar La Ruca',
    @NombreFormula = 'Fórmula DDL Untable Ruca 2025',
    @DescripcionFormula = 'Ideal para rellenos, 62% sólidos, color caramelo claro, sabor equilibrado.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;

-- 9. Dulce de leche clásico para untar La Chacarera
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar La Chacarera',
    @NombreFormula = 'Fórmula DDL Untable Chacarera 2025',
    @DescripcionFormula = 'Textura firme, 63% sólidos, color caramelo medio, para consumo directo y rellenos.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;

-- 10. Dulce de leche clásico para untar El Gauchito
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar El Gauchito',
    @NombreFormula = 'Fórmula DDL Untable Gauchito 2025',
    @DescripcionFormula = 'Sabor intenso, 61% sólidos, color caramelo oscuro, para rellenos premium.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;

-- 11. Dulce de leche clásico para untar El Bombón
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar El Bombón',
    @NombreFormula = 'Fórmula DDL Untable Bombón 2025',
    @DescripcionFormula = 'Cremoso y dulce, 62% sólidos, color caramelo claro, para consumo directo.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria02, @IdFormula = @IdFormula;

-- 12. Dulce de leche clásico para untar La Abuela
exec usp_insertar_formula_producto
    @DescripcionProducto = 'Dulce de leche clásico para untar La Abuela',
    @NombreFormula = 'Fórmula DDL Untable Abuela 2025',
    @DescripcionFormula = 'Textura tradicional, 60% sólidos, color caramelo medio, sabor casero.',
    @CodProductoSalida = @CodProducto output,
    @IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;


go
--QUE FALTA
-- Deposito

-- Obtenemos los IdSector
declare @ReciboId int, @PolvosId int, @DulceriaId int, @NanoId int;

select @ReciboId = IdSector from Sector where Nombre = 'Recibo';
select @PolvosId = IdSector from Sector where Nombre = 'Polvos';
select @DulceriaId = IdSector from Sector where Nombre = 'Dulceria';
select @NanoId = IdSector from Sector where Nombre = 'Nano y Concentrados';

-- Depositos sector Recibo (recepción de materia prima láctea)
insert into Deposito (Nombre, Descripcion, IdSector) values
('Tanque Leche Cruda 1', 'Tanque de recepción de leche cruda 1', @ReciboId),
('Tanque Leche Cruda 2', 'Tanque de recepción de leche cruda 2', @ReciboId),
('Tanque Agua', 'Tanque para agua de proceso', @ReciboId),
('Tanque Crema', 'Tanque para crema', @ReciboId);

-- Depositos sector Polvos (almacenamiento de ingredientes en polvo)
insert into Deposito (Nombre, Descripcion, IdSector) values
('Silo Leche en Polvo', 'Silo para leche en polvo', @PolvosId),
('Silo Suero en Polvo', 'Silo para suero en polvo', @PolvosId),
('Silo Caseína', 'Silo para caseína en polvo', @PolvosId),
('Depósito Aditivos', 'Depósito para aditivos en polvo', @PolvosId),
('Depósito Envases Polvo', 'Depósito para envases de polvo', @PolvosId);

-- Depositos sector Dulcería (almacenamiento y proceso de productos dulces lácteos)
insert into Deposito (Nombre, Descripcion, IdSector) values
('Depósito Azúcar', 'Depósito de azúcar para dulcería', @DulceriaId),
('Tanque Jarabe', 'Tanque para jarabes', @DulceriaId),
('Depósito Saborizantes', 'Depósito para saborizantes', @DulceriaId),
('Depósito Empaques Dulces', 'Depósito de empaques para dulces', @DulceriaId);

-- Depositos sector Nano y Concentrados (almacenamiento de productos concentrados y nano)
insert into Deposito (Nombre, Descripcion, IdSector) values
('Tanque Concentrado Proteico', 'Tanque para concentrado proteico', @NanoId),
('Tanque Concentrado Grasa', 'Tanque para concentrado de grasa', @NanoId),
('Depósito Nano Partículas', 'Depósito para nano partículas', @NanoId),
('Depósito Ingredientes Activos', 'Depósito para ingredientes activos', @NanoId),
('Depósito Envases Concentrados', 'Depósito para envases de concentrados', @NanoId);
go

-- UnidadMedida
insert into UnidadMedida (Nombre, Descripcion)
values
('KG', 'Kilogramo'),
('GR', 'Gramo'),
('LT', 'Litro'),
('ML', 'Mililitro'),
('PO25', 'Pote de 25 gramos'),
('PO400', 'Pote de 400 gramos'),
('BSA25', 'Bolsa de 25 kilogramos'),
('BSA50', 'Bolsa de 50 kilogramos'),
('BSA100', 'Bolsa de 100 kilogramos'),
('UN', 'Unidad'),
('CAJA', 'Caja de productos'),
('BIDON', 'Bidón de almacenamiento'),
('SACO', 'Saco de material'),
('BARRIL', 'Barril o tonel'),
('MTS', 'Metro (longitud)'),
('CM', 'Centímetro (longitud)');
go


-- Crear insumos, digamos productos de tipo insumo
-- bolsas papel kraft
-- Como hacemos inserción manual, arranca en 50 porque arriba hicimos inserción usando el identity.
set IDENTITY_INSERT Producto on;

insert into Producto (CodProducto, Descripcion) values
(51, 'Bolsas de papel Kraft multicapa de 25 kg'),
(52, 'Separadores de cartón para filas de 5 bolsas'),
(53, 'Esquineros de cartón para protección estructural'),
(54, 'Film stretch para inmovilizar carga'),
(55, 'Bolsas de papel aluminizado trilaminadas de 800 g'),
(56, 'Cajas máster corrugadas para 7 bolsas'),
(57, 'Separadores de cartón internos'),
(58, 'Etiquetas con datos nutricionales'),
(59, 'Etiquetas RFID para trazabilidad logística'),
(60, 'Cajas con recubrimiento antihumedad interno'),
(61, 'Caja máster para leche en polvo x 400 g'),
(62, 'Caja máster para leche en polvo x 800 g'),
(63, 'Bolsa para leche entera sin impresión, envasado automático 53x92x14 cm'),
(64, 'Bolsa para suero en polvo con impresión, envasado automático 53x97x14 cm'),
(65, 'Bolsa para polvo con impresión, envasado automático 53x97x14 cm'),
(66, 'Separador para palletizar de 1 x 1.20 mts'),
(67, 'Termoetiqueta 58 x 43 mm cono 70'),
(68, 'Pallets de madera estandarizados'),
(69, 'Film stretch para pallets'),
(70, 'Hipoclorito de sodio al 100%'),
(71, 'Producto de limpieza industrial (Deptacid NT)'),
(72, 'Soda cáustica (hidróxido de sodio)'),
(73, 'Recupero de gruesos polvos'),
(74, 'Separadores de cartón para cajas'),
(75, 'Cinta de seguridad industrial'),
(76, 'Envase plástico para dulce de leche 400 g (fit)'),
(77, 'Envase plástico para dulce de leche 400 g (repostero)'),
(78, 'Envase plástico para dulce de leche 1 kg (repostero)'),
(79, 'Tapa de aluminio para envase plástico 1 kg'),
(80, 'Etiqueta para dulce de leche 450 g'),
(81, 'Envase plástico para dulce de leche 1 kg (familiar)'),
(82, 'Caja cartón para 6 envases de 1 kg de dulce de leche'),
(83, 'Bobina para sachet de dulce de leche 12.5 kg'),
(84, 'Azúcar blanca común en bolsón de 1250 kg'),
(85, 'Gelificante con maltodextrina en bolsa de 25 kg'),
(86, 'Materia prima desodorizada a granel'),
(87, 'Alfajorero base con reducción calórica'),
(88, 'Separadores antideslizantes 1200x1000 mm'),
(89, 'Relleno alfajorero en pouch de 12.5 kg'),
(90, 'Dióxido de titanio'),
(91, 'Envase plástico 4 kg blanco sin impresión'),
(92, 'Recupero dulce relleno'),
(93, 'Caja wrap around 6 x 800 g marrón lisa');

set IDENTITY_INSERT Producto off;

go

-- Comprar estos productos

-- Insertar proveedores con id manual
set IDENTITY_INSERT Proveedor on;

-- Insertar datos con ID manualmente
insert into Proveedor (IdProveedor, Nombre, Calle, Nro, Localidad) values
(1, 'Empack Solutions S.A.', 'Av. Siempre Viva', '123', 'Adrogué'),
(2, 'TecnoEnvases SRL', 'Calle Falsa', '456', 'Berazategui'),
(3, 'Grupo Barriopack', 'Rivadavia', '789', 'Lanús Este'),
(4, 'Envaflex Industrial', 'San Martín', '101', 'Lomas de Zamora'),
(5, 'Cartonería del Centro', 'Belgrano', '202', 'Mar del Plata'),
(6, 'Fábrica de Bolsas El Trébol', 'Mitre', '303', 'San Justo'),
(7, 'Industrias Fuellex S.A.', '9 de Julio', '404', 'Quilmes'),
(8, 'PlastiAndes SRL', 'Santa Fe', '505', 'Villa Gesell'),
(9, 'Cartonpack Argentina', 'Corrientes', '606', 'Avellaneda'),
(10, 'Zonda Films y Empaques', 'Perón', '707', 'Bahía Blanca'),
(11, 'Multicapas del Litoral', 'Córdoba', '808', 'Pinamar'),
(12, 'EcoPacking Solutions', 'Urquiza', '909', 'Rafael Calzada'),
(13, 'SelloSeguro S.R.L.', 'Chacabuco', '111', 'Tandil'),
(14, 'Burbuja Pack Express', '9 de Julio', '222', 'San Clemente del Tuyú'),
(15, 'TecniGlass Empaques', 'Libertad', '333', 'Lanús Oeste'),
(16, 'Corrugados del Sur S.A.', 'Sarmiento', '444', 'Mar Azul'),
(17, 'VálvulaPack Industrial', 'Belgrano', '555', 'Olavarría'),
(18, 'Envases Higiénicos Mendoza', 'Mitre', '666', 'Villa Fiorito'),
(19, 'Precintados La Esperanza', 'Hipólito Yrigoyen', '777', 'Ezpeleta'),
(20, 'TetraDistribuidora S.A.', 'San Juan', '888', 'San Justo'),
(21, 'Bolsaflex Industrial S.A.', 'Avenida Textil', '1234', 'Morón'),
(22, 'Química Pampeana S.A.', 'Camino Industrial', '567', 'Santa Rosa'),
(23, 'PlastiPack SRL', 'Ruta 8', '7890', 'General Rodríguez'),
(24, 'AluTapas Argentina S.A.', 'Aluminio', '321', 'San Martín'),
(25, 'FlexiFilm Industrial S.A.', 'Filmación', '654', 'Villa Adelina'),
(26, 'Azucarera del Norte S.A.', 'Azucarera Central', '101', 'Tucumán'),
(27, 'Ingredientes Técnicos S.A.', 'Ingrediente', '202', 'Córdoba'),
(28, 'Lácteos Técnicos S.A.', 'Lechería', '303', 'Villa María');

set IDENTITY_INSERT Proveedor off;

go

-- Nombres: 'Empack Solutions S.A.', 'TecnoEnvases SRL', 'Grupo Barriopack', 'Envaflex Industrial', 'Cartonería del Centro', 'Fábrica de Bolsas El Trébol', 'Industrias Fuellex S.A.', 'PlastiAndes SRL', 'Cartonpack Argentina', 'Zonda Films y Empaques', 'Multicapas del Litoral', 'EcoPacking Solutions', 'SelloSeguro S.R.L.', 'Burbuja Pack Express', 'TecniGlass Empaques', 'Corrugados del Sur S.A.', 'VálvulaPack Industrial', 'Envases Higiénicos Mendoza', 'Precintados La Esperanza', 'TetraDistribuidora S.A.'


-- Insertar Teléfonos (números inventados)
insert into Telefono (Numero) values
('11-1234-5678'), ('11-2345-6789'), ('223-456-7890'), ('223-456-7891'),
('11-3456-7890'), ('223-567-8901'), ('11-4567-8901'), ('223-678-9012'),
('11-5678-9012'), ('223-789-0123'), ('11-6789-0123'), ('223-890-1234'),
('11-7890-1234'), ('223-901-2345'), ('11-8901-2345'), ('223-012-3456'),
('11-9012-3456'), ('223-123-4567'), ('11-0123-4567'), ('223-234-5678'),
('11-1111-1111'), ('223-222-2222'), ('11-3333-3333'), ('223-444-4444'),
('11-5555-5555'), ('223-666-6666'), ('11-7777-7777'), ('223-888-8888'),
('11-9999-9999'), ('223-000-0000');

-- Vincular Proveedores con Teléfonos (IdProveedor y IdTelefono correlativos)
-- 1 teléfono para proveedor 1, 2 para proveedor 2, 1 para proveedor 3, 3 para proveedor 4, etc.

insert into ProveedorTelefono (IdProveedor, IdTelefono) values
(1, 1),
(2, 2), (2, 3),
(3, 4),
(4, 5), (4, 6), (4, 7),
(5, 8),
(6, 9), (6, 10),
(7, 11),
(8, 12),
(9, 13), (9, 14),
(10, 15),
(11, 16), (11, 17), (11, 18),
(12, 19),
(13, 20),
(14, 21), (14, 22),
(15, 23),
(16, 24), (16, 25),
(17, 26),
(18, 27),
(19, 28), (19, 29),
(20, 30);
go
