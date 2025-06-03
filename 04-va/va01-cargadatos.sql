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

-- Sectores

insert into Sector (Nombre)
values
('Recibo'),
('Polvos'),
('Dulceria'),
('Nano y Concentrados');

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


-- Dulcería
-- Nano y Concentrados
-- Roles
-- RolesPermisos
-- Usuarios
-- UsuariosRoles
