/************************************************************
 *                CREACIÓN DE BASE DE DATOS                 *
 ************************************************************/

use master;

create database vaquissima01;
go

use vaquissima01;
go


-- -- Para crear usuario owner
-- use va05;
-- create user NombreUsuario for login NombreUsuario;
-- alter role db_owner add member NombreUsuario;


-- -- Este sp es para crear un usuario nuevo y darle una contraseña.
-- -- Se crea su login y ademas se le hace owner de la base de datos.
-- -- Es para poder ingresar desde vscode. (descargar extension sqlserver - microsoft)
-- -- Ser admin para ejecutar el sp.
-- create procedure sp_crear_usuario_login_y_owner_para_vscode
--     @db nvarchar(100),
--     @usuario nvarchar(100),
--     @password nvarchar(100)
-- as
-- begin
--     set nocount on;

--     declare @sql nvarchar(MAX)
--     declare @sql2 nvarchar(MAX)

--     -- Crear login para pode ingresar con contraseña y no con autenticación de windows
--     -- OJO: para ejecutar se debe ser administrador
--     if not exists (select 1 from sys.server_principals where name = @usuario)
--     begin
--         -- lo tuve que ahcer asi porque el usuario es literal no texto y no puedo usar nvarchar ->
--         set @sql = N'create login ' + quotename(@usuario) +
--                    N' with password = ' + quotename(@password, '''') + 
--                    N', check_policy = on;';
--         exec sp_executesql @sql
--     end


--     set @sql2 = N'use ' + quotename(@db) + ';
--                 if not exists (
--                     select 1 from sys.database_principals where name = ' + quotename(@usuario, '''') + ')
--                 begin
--                     create user ' + quotename(@usuario) + ' for login ' + quotename(@usuario) + ';
--                     alter role db_owner add member ' + quotename(@usuario) + ';
--                 end;';

--     exec sp_executesql @sql2
-- end
-- go

-- -- correr primero el sp y despues esto para ingresar con un usuario desde vscode con contraseña
-- -- y no usar el autenticador windows. HAY QUE SER ADMIN para ejecutar esto
-- exec sp_crear_usuario_login_y_owner_para_vscode 'nombre_db', 'nombre_usuario_nuevo', 'contrasenia_usuario_nuevo'


-- Crear base de datos

-- RBAC

create table Usuario (
    IdUsuario int identity(1,1),
    Clave nvarchar(100) not null,
    Nombre nvarchar(50) not null,
    Apellido nvarchar(50),
    Email nvarchar(254) not null, -- segun RFC
    FechaAlta datetime not null default getdate(),

    constraint PK_Usuario primary key (IdUsuario),
    constraint UQ_Usuario_Email unique (Email),
    constraint CK_Usuario_Email check (Email like '_%@_%._%')
);

create table Rol (
    IdRol int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),

    constraint PK_Rol primary key (IdRol),
    constraint UQ_Rol_nombre unique (Nombre)
);

create table UsuarioRol (
    IdUsuario int,
    IdRol int,
    FechaAltaRol datetime not null default getdate(),

    constraint PK_UsuarioRol primary key (IdUsuario, IdRol),
    constraint FK_UsuarioRol_Usuario foreign key (IdUsuario) references Usuario(IdUsuario)
        on delete cascade,
    constraint FK_UsuarioRol_Rol foreign key (IdRol) references Rol(IdRol)
        on delete cascade
);

create table Sector (
    IdSector int identity(1,1),
    Nombre nvarchar(100) not null,
    --Descripcion nvarchar(255), CAMBIOS: es redundante ya con nombre se entiende

    constraint PK_Sector primary key (IdSector),
    constraint UQ_Sector_Nombre unique (Nombre)
);

-- Permisos mas generales
create table Permiso (
    IdPermiso int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar (255),

    constraint PK_Permiso primary key (IdPermiso),
    constraint UQ_Permiso_Nombre unique (Nombre)
);

-- CAMBIOS: Hereda de permiso y es mas especifico ara Ordenes y Sectores
create table PermisoOrdenSector (
    IdPermiso int not null,
    TipoOrden varchar(30) not null,
    IdSector int,
    Accion varchar(10) not null,

    constraint PK_PermisoOrdenSector primary key(IdPermiso),
    constraint FK_PermisoOrdenSector_Permiso foreign key (IdPermiso) references Permiso(IdPermiso),
    constraint FK_PermisoOrdenSector_Sector foreign key (IdSector) references Sector(IdSector),
    constraint CK_PermisoOrdenSector_Accion check (Accion in ('Leer', 'Crear', 'Editar', 'Borrar')),
    constraint CK_PermisoOrdenSector_TipoOrden check (TipoOrden in ('OrdenFabricacion', 'OrdenEntrega', 'OrdenCompra', 'OrdenReposicion')),

    -- Para que no existan duplicados en distintos permisos
    constraint UQ_PermisoOrdenSector_Unicidad unique (TipoOrden, IdSector, Accion)
);

create table RolPermiso (
    IdRol int,
    IdPermiso int,

    constraint PK_RolPermiso primary key (IdRol, IdPermiso),
    constraint FK_RolPermiso_Rol foreign key (IdRol) references Rol(IdRol) on delete cascade,
    constraint FK_RolPermiso_Permiso foreign key (IdPermiso) references Permiso(IdPermiso) on delete cascade
);

create table Producto (
    CodProducto int identity(1,1),
    Descripcion nvarchar(255) not null,
    -- CAMBIO: Se quito FK de formula y se agrego a la tabla formula

    constraint PK_Producto primary key (CodProducto)
);

create table Formula (
    IdFormula int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),
    CodProducto int not null,  -- CAMBIO: Se quito de producto se agrego a formula

    constraint PK_Formula primary key (IdFormula),
    constraint UQ_Formula_Nombre unique (Nombre),
    constraint FK_Formula_Producto foreign key (CodProducto) references Producto(CodProducto)
);

create table UsuarioFormula (
    IdUsuario int,
    IdFormula int,

    constraint PK_UsuarioFormula primary key (IdUsuario, IdFormula),
    constraint FK_UsuarioFormula_Usuario foreign key (IdUsuario) references Usuario(IdUsuario) on delete cascade,
    constraint FK_UsuarioFormula_Formula foreign key (IdFormula) references Formula(IdFormula) on delete cascade
);


create table Linea (
    IdLinea int identity(1,1),
    IdSector int not null,
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),

    constraint PK_Linea primary key (IdLinea),
    constraint FK_Linea_Sector foreign key (IdSector) references Sector(IdSector), -- podria poner delete cascada pero prefiero que si se borra sector se vea manualmente las lineas
    constraint UQ_Linea_Nombre unique (Nombre)
);

create table EstadoOF (
    IdEstadoOF int identity(1,1),
    Nombre varchar(11) not null,

    constraint PK_EstadoOF primary key (IdEstadoOF),
    constraint UQ_EstadoOF_Nombre unique (Nombre),
    constraint CK_EstadoOF_Nombre check (
        Nombre in ('Planificado', 'En Proceso', 'Cerrado', 'Calidad')
    ) -- no es case sensitive
);

create table OrdenFabricacion (
    NroFabricacion int identity(1,1),
    IdFormula int not null,
    IdLinea int not null,
    IdEstadoOF int not null,
    IdUsuario int not null,
    FechaPlanificacion datetime not null default getdate(),
    FechaInicio datetime,
    FechaFin datetime,
    EsAnulado bit not null default 0,
    
    constraint PK_OrdenFabricacion primary key (NroFabricacion),
    constraint FK_OrdenFabricacion_Formula foreign key (IdFormula) references Formula(IdFormula),
    constraint FK_OrdenFabricacion_Linea foreign key (IdLinea) references Linea(IdLinea),
    constraint FK_OrdenFabricacion_EstadoOF foreign key (IdEstadoOF) references EstadoOF(IdEstadoOF),
    constraint FK_OrdenFabricacion_Usuario foreign key (IdUsuario) references Usuario(IdUsuario),
    
    constraint CK_OrdenFabricacion_FechaInicio check (
        FechaInicio is null or FechaInicio >= FechaPlanificacion
    ),
    constraint CK_OrdenFabricacion_FechaFin check (
        FechaFin is null or FechaFin >= FechaInicio
    )
);

create table UnidadMedida (
    IdUM int identity(1,1),
    Nombre nvarchar(50) not null,
    Descripcion nvarchar(255),

    constraint PK_UnidadMedida primary key (IdUM),
    constraint UQ_UnidadMedida_Nombre unique (Nombre)
);

create table Deposito (
    IdDeposito int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),
    --CAMBIOS: agrego relacion con sector
    IdSector int not null,

    constraint PK_Deposito primary key (IdDeposito),
    constraint UQ_Deposito_Nombre unique (Nombre),
    constraint PK_Deposito_Sector foreign key (IdSector) references Sector(IdSector)
);

create table MovimientoStock (
    IdMovimiento int identity(1,1),
    CodProducto int not null,
    IdDeposito int not null,
    IdUM int not null,

    FechaVencimiento datetime not null,
    FechaMovimiento datetime not null default getdate(),
    TipoMovimiento varchar(7) not null,
    CantidadModificada decimal(15,2) not null,
    --Lote nvarchar(255) not null, -- CodProducto-FechaVencimiento

    constraint PK_MovimientoStock primary key (IdMovimiento),
    constraint FK_MovimientoStock_Producto foreign key (CodProducto) references Producto(CodProducto),
    constraint FK_MovimientoStock_Deposito foreign key (IdDeposito) references Deposito(IdDeposito),
    constraint FK_MovimientoStock_UnidadMedida foreign key (IdUM) references UnidadMedida(IdUM),
    constraint CK_MovimientoStock_TipoMovimiento check (TipoMovimiento in ('Ingreso', 'Egreso', 'Espera')) -- CAMBIOS: Se agrega espera
    -- Ya por ejemplo en órdenes de compra se tiene que esperar para hacer válido el movimiento hasta que se reciba el producto.
    -- entonces el estado espera significa que espera a las órdenes a que estén en los estados correctos.
    -- el dato está cargado pero se filtra para que no aparezca en stock.
);

create table MovimientoFabricacion (
    IdMovimiento int,
    NroFabricacion int,
    Destino varchar(7) not null,
    Calidad nvarchar(50) not null,

    constraint PK_MovimientoFabricacion primary key (IdMovimiento, NroFabricacion),
    constraint FK_MovimientoFabricacion_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoFabricacion_OrdenFabricacion foreign key (NroFabricacion) references OrdenFabricacion(NroFabricacion),
    constraint CK_MovimientoFabricacion_Destino check (Destino in ('Venta', 'Muestra')),
    constraint CK_MovimientoFabricacion_Calidad check (Calidad in ('Requiere', 'Transferencia Directa'))
);

create table EstadoOR (
    IdEstadoOR int identity(1,1),
    Nombre varchar(10) not null,

    constraint PK_EstadoOR primary key (IdEstadoOR),
    constraint UQ_EstadoOR_Nombre unique (Nombre),
    constraint CK_EstadoOR_Nombre check (Nombre in ('Proceso', 'Solicitado', 'Cerrado'))
);

create table OrdenReposicion (
    NroReposicion int identity(1,1),
    IdEstadoOR int not null,
    EsAnulado bit not null default 0,
    
    constraint PK_OrdenReposicion primary key (NroReposicion),
    constraint FK_OrdenReposicion_EstadoOR foreign key (IdEstadoOR) references EstadoOR(IdEstadoOR)
);

create table OrdenReposicionDetalle (
    NroReposicion int,
    CodProducto int,
    IdUM int not null, -- CAMBIOS: se agrego
    Cantidad decimal(15,2),


    constraint PK_OrdenReposicionDetalle primary key (NroReposicion, CodProducto),
    constraint FK_OrdenReposicionDetalle_OrdenReposicion foreign key (NroReposicion) references OrdenReposicion(NroReposicion),
    constraint FK_OrdenReposicionDetalle_Producto  foreign key (CodProducto) references Producto(CodProducto),
    constraint FK_OrdenReposicionDetalle_UnidadMedida foreign key (IdUM) references UnidadMedida(IdUM),
    constraint CK_OrdenReposicionDetalle_Cantidad check (Cantidad >= 0)
);

create table EstadoOE (
    IdEstadoOE int identity(1,1),
    Nombre varchar(8) not null,

    constraint PK_EstadoOE primary key (IdEstadoOE),
    constraint UQ_EstadoOE_Nombre unique (Nombre),
    constraint CK_EstadoOE_Nombre check (Nombre in ('Proceso', 'Enviado', 'Recibido'))
);

create table OrdenEntrega (
    NroEntrega int identity(1,1),
    SectorSolicita int not null,
    SectorProvee int not null,
    DepositoSolicita int not null,
    DepositoProvee int,
    UsuarioAlta int not null,
    UsuarioRecepcion int,
    IdEstadoOE int not null,
    FechaAlta datetime not null default getdate(),
    FechaRecepcion datetime,
    EsAnulado bit not null default 0,

    constraint PK_OrdenEntrega primary key (NroEntrega),
    constraint FK_OrdenEntrega_Sector_Solicita foreign key (SectorSolicita) references Sector(IdSector),
    constraint FK_OrdenEntrega_Sector_Provee foreign key (SectorProvee) references Sector(IdSector),
    constraint FK_OrdenEntrega_Deposito_Solicita foreign key (DepositoSolicita) references Deposito(IdDeposito),
    constraint FK_OrdenEntrega_Deposito_Provee foreign key (DepositoProvee) references Deposito(IdDeposito),
    constraint FK_OrdenEntrega_Usuario_Alta foreign key (UsuarioAlta) references Usuario(IdUsuario),
    constraint FK_OrdenEntrega_Usuario_Recepcion foreign key (UsuarioRecepcion) references Usuario(IdUsuario),
    constraint FK_OrdenEntrega_EstadoOE foreign key (IdEstadoOE) references EstadoOE(IdEstadoOE),
    constraint CK_OrdenEntrega_FechaRecepcion check (
        FechaRecepcion is null or FechaRecepcion >= FechaAlta
    )
);

create table MovimientoEntrega (
    IdMovimiento int,
    NroEntrega int,

    constraint PK_MovimientoEntrega primary key (IdMovimiento, NroEntrega),
    constraint FK_MovimientoEntrega_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoEntrega_OrdenEntrega foreign key (NroEntrega) references OrdenEntrega(NroEntrega)
);

create table TipoPallet (
    IdTipoPallet int identity(1,1),
    IdUM int not null,
    Nombre nvarchar(50) not null,
    Capacidad int, -- se tiene que restringir a Unidades de Medida que no sean decimales.

    constraint PK_TipoPallet primary key (IdTipoPallet),
    constraint FK_TipoPallet_UnidadMedida foreign key (IdUM) references UnidadMedida(IdUM),
    constraint UQ_TipoPallet_Nombre unique (Nombre),
    constraint CK_TipoPallet_Capacidad check (Capacidad > 0)
);

create table Pallet (
    IdPallet int identity(1,1),
    IdTipoPallet int not null,
    CantidadDisponible int, -- Se calcula con movimientos Pallet

    constraint PK_Pallet primary key (IdPallet),
    constraint FK_Pallet_TipoPallet foreign key (IdTipoPallet) references TipoPallet(IdTipoPallet),
    constraint CK_Pallet_CantidadDisponible check (CantidadDisponible >= 0)
);

create table MovimientoPallet (
    IdMovimiento int,
    IdPallet int,

    constraint PK_MovimientoPallet primary key (IdMovimiento, IdPallet),
    constraint FK_MovimientoPallet_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoPallet_Pallet foreign key (IdPallet) references Pallet(IdPallet)
);

create table Telefono (
    IdTelefono int identity(1,1),
    Numero nvarchar(30) not null, -- esta simplificado sino tendria que poner codigo de area, etc

    constraint PK_Telefono primary key (IdTelefono),
    constraint UQ_Telefono_Numero unique (Numero)
);

-- Proveedor
create table Proveedor (
    IdProveedor int identity(1,1),
    Nombre nvarchar(50) not null,
    Calle nvarchar(100),
    Nro nvarchar(20),
    Localidad nvarchar(100),
    constraint PK_Proveedor primary key (IdProveedor),
    constraint UQ_Proveedor_Nombre unique (Nombre)
);

-- CAMBIOS: agregamos ProveedorTelefono por si tiene mas de un teléfono
create table ProveedorTelefono (
    IdProveedor int,
    IdTelefono int,

    constraint PK_ProveedorTelefono primary key (IdProveedor, IdTelefono),
    constraint FK_ProveedorTelefono_Proveedor foreign key (IdProveedor) references Proveedor(IdProveedor),
    constraint FK_ProveedorTelefono_Telefono foreign key (IdTelefono) references Telefono(IdTelefono)
);

create table EstadoOC (
    IdEstadoOC int identity(1,1),
    Nombre varchar(10) not null,

    constraint PK_EstadoOC primary key (IdEstadoOC),
    constraint UQ_EstadoOC_Nombre unique (Nombre),
    constraint CK_EstadoOC_Nombre check (Nombre in ('Solicitada', 'Recibida'))
);

create table OrdenCompra (
    NroCompra int identity(1,1),
    IdProveedor int not null,
    IdUsuario int not null,
    IdEstadoOC int not null,
    FechaCompra datetime not null default getdate(),

    constraint PK_OrdenCompra primary key (NroCompra),
    constraint FK_OrdenCompra_Proveedor foreign key (IdProveedor) references Proveedor(IdProveedor),
    constraint FK_OrdenCompra_Usuario foreign key (IdUsuario) references Usuario(IdUsuario),
    constraint FK_OrdenCompra_EstadoOC foreign key (IdEstadoOC) references EstadoOC(IdEstadoOC)
);

create table MovimientoCompra (
    IdMovimiento int,
    NroCompra int,
    PrecioUnitario decimal(18,2) not null,
    -- Cantidad int not null, -- CAMBIOS: se agrego NO SE NECESITA ESTA EN MOVIMIENTO STOCK

    constraint PK_MovimientoCompra primary key (IdMovimiento, NroCompra),
    constraint FK_MovimientoCompra_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoCompra_OrdenCompra foreign key (NroCompra) references OrdenCompra(NroCompra),
    --constraint CK_MovimientoCompra_Cantidad check (Cantidad > 0),
    constraint CK_MovimientoCompra_PrecioUnitario check (PrecioUnitario >= 0)
);
go

/************************************************************
 *                     CARGA DE DATOS                       *
 ************************************************************/

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
values (1, 'MateAmargo2025!', 'Pepe', 'Argento', 'pepe.argento@gmail.com');


-- Usuarios para ordenes de compra
insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (2, 'AveCesar#Imperium', 'Augusto', 'Cesar', 'augusto.cesar@gmail.com');

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (3, 'LocuraReal_1496', 'Juana', 'La Loca', 'juana.laloca@gmail.com');

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (4, 'Tango&Fernet_22', 'Carlos', 'Martínez', 'carlos.martinez@gmail.com');

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (5, 'LaVidaEsQueso!', 'María', 'Pérez', 'maria.perez@gmail.com');

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (6, 'LuchoTheCoder#9', 'Luis', 'Fernández', 'luis.fernandez@gmail.com');

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (7, 'García$2025#Café', 'Ana', 'García', 'ana.garcia@gmail.com');

insert into Usuario (IdUsuario, Clave, Nombre, Apellido, Email)
values (8, 'L0pezRock&Roll', 'Ricardo', 'López', 'ricardo.lopez@gmail.com');



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
    @CodProducto int,
    @IdFormula int,
    @DescripcionProducto nvarchar(255),
    @NombreFormula nvarchar(100),
    @DescripcionFormula nvarchar(255)
    --@CodProductoSalida int output,
    --@IdFormulaSalida int output
as
begin
    set nocount on;
    begin try
        begin transaction;

        declare @CodProductoSalida int;
        declare @IdFormulaSalida int;

        set IDENTITY_INSERT Producto on;
        -- Insertar Producto
        insert into Producto (CodProducto, Descripcion)
        values (@CodProducto, @DescripcionProducto);
        set IDENTITY_INSERT Producto off;

        --set @CodProductoSalida = scope_identity(); -- Vamos a forzar los ids
        set @CodProductoSalida = @CodProducto;

        set @IdFormulaSalida = @IdFormula;
        -- Insertar Formula
        set IDENTITY_INSERT Formula on;
        insert into Formula (IdFormula, Nombre, Descripcion, CodProducto)
        values (@IdFormula, @NombreFormula, @DescripcionFormula, @CodProductoSalida);

        --set @IdFormulaSalida = scope_identity();
        set IDENTITY_INSERT Formula off;

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
    @CodProducto = 1,
    @IdFormula = 1,
    @DescripcionProducto = 'Dulce de leche repostero industrial',
    @NombreFormula = 'Fórmula DDL Repostero Alta Consistencia',
    @DescripcionFormula = 'Formula con alta proporción de sólidos totales, 70%, menor humedad, ideal para horneado y repostería.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

--exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula; -- el usuario 1 es el admin
exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 1; -- admin
--exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 1;

-- 2. Dulce de leche clásico para untar (marca blanca)
exec usp_insertar_formula_producto
    @CodProducto = 2,
    @IdFormula = 2,
    @DescripcionProducto = 'Dulce de leche clásico para untar Marca Blanca',
    @NombreFormula = 'Fórmula DDL Untable Estándar 2025',
    @DescripcionFormula = 'Formula con textura suave, 62% sólidos, color caramelo claro, pensada para consumo directo.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 2;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria02, @IdFormula = 2;


-- 3. Dulce de leche para alfajores premium (exportación)
exec usp_insertar_formula_producto
    @CodProducto = 3,
    @IdFormula = 3,
    @DescripcionProducto = 'Dulce de leche alfajor exportación',
    @NombreFormula = 'Fórmula Export Premium 75%',
    @DescripcionFormula = 'Alto contenido en sólidos (75%), color oscuro, sabor intenso, diseñado para exportación a Europa.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 3;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 3;


-- 4. Dulce de leche baja lactosa
exec usp_insertar_formula_producto
    @CodProducto = 4,
    @IdFormula = 4,
    @DescripcionProducto = 'Dulce de leche baja en lactosa',
    @NombreFormula = 'Fórmula DDL Lactosa Reducida',
    @DescripcionFormula = 'Tratamiento enzimático previo, menor contenido de lactosa (<0.5%), sabor tradicional conservado.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 4;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 4;


-- 5. Leche en polvo entera
exec usp_insertar_formula_producto
    @CodProducto = 5,
    @IdFormula = 5,
    @DescripcionProducto = 'Leche en polvo entera 26% grasa',
    @NombreFormula = 'Fórmula LPE 26 Alta Solubilidad',
    @DescripcionFormula = 'Secado spray, grasa 26%, diseñada para disolución instantánea en agua caliente o fría.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 5;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 5;


-- 6. Leche en polvo descremada
exec usp_insertar_formula_producto
    @CodProducto = 6,
    @IdFormula = 6,
    @DescripcionProducto = 'Leche en polvo descremada <1% grasa',
    @NombreFormula = 'Fórmula LPD Ultra Light',
    @DescripcionFormula = 'Baja en grasa, alto contenido proteico, ideal para aplicaciones dietéticas y deportivas.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 6;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 6;




-- Mas leches en polvo:
-- 1. Leche en polvo descremada Rastafari <1% grasa
exec usp_insertar_formula_producto
    @CodProducto = 7,
    @IdFormula = 7,
    @DescripcionProducto = 'Leche en polvo descremada Rastafari <1% grasa',
    @NombreFormula = 'Fórmula LPD Rastafari Ultra Light',
    @DescripcionFormula = 'Baja en grasa, alto contenido proteico, ideal para panificación y alimentos infantiles.';
    --@CodProductoSalida = @CodProducto output,
    --@IdFormulaSalida = @IdFormula output;

-- exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 7;
-- exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = @IdFormula;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 7;

-- 2. Leche en polvo entera Habanito 26% grasa
exec usp_insertar_formula_producto
    @CodProducto = 8,
    @IdFormula = 8,
    @DescripcionProducto = 'Leche en polvo entera Habanito 26% grasa',
    @NombreFormula = 'Fórmula LPE Habanito Cremosa',
    @DescripcionFormula = 'Alta en grasa para un sabor cremoso y textura óptima en repostería.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 8;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 8;

-- 3. Leche en polvo descremada Capitán del Cosmo <1% grasa
exec usp_insertar_formula_producto
    @CodProducto = 9,
    @IdFormula = 9,
    @DescripcionProducto = 'Leche en polvo descremada Capitán del Cosmo <1% grasa',
    @NombreFormula = 'Fórmula LPD Cosmo Ultra Light',
    @DescripcionFormula = 'Bajo en grasa, ideal para producción de alimentos infantiles y dietéticos.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 9;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 9;

-- 4. Leche en polvo entera La Porteña 25% grasa
exec usp_insertar_formula_producto
    @CodProducto = 10,
    @IdFormula = 10,
    @DescripcionProducto = 'Leche en polvo entera La Porteña 25% grasa',
    @NombreFormula = 'Fórmula LPE Porteña Cremosa',
    @DescripcionFormula = 'Perfecta para uso en panadería y elaboración de alfajores con sabor intenso.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 10;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 10;

-- 5. Leche en polvo descremada El Correntino <0.5% grasa
exec usp_insertar_formula_producto
    @CodProducto = 11,
    @IdFormula = 11,
    @DescripcionProducto = 'Leche en polvo descremada El Correntino <0.5% grasa',
    @NombreFormula = 'Fórmula LPD Correntino Light',
    @DescripcionFormula = 'Muy baja en grasa, alto contenido proteico para uso industrial y dietético.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 11;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 11;

-- 6. Leche en polvo entera La Ruca 27% grasa
exec usp_insertar_formula_producto
    @CodProducto = 12,
    @IdFormula = 12,
    @DescripcionProducto = 'Leche en polvo entera La Ruca 27% grasa',
    @NombreFormula = 'Fórmula LPE Ruca Extra Cremosa',
    @DescripcionFormula = 'Alta cremosidad y sabor pleno, recomendada para rellenos y productos lácteos premium.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 12;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 12;

-- 7. Leche en polvo descremada La Chacarera <1% grasa
exec usp_insertar_formula_producto
    @CodProducto = 13,
    @IdFormula = 13,
    @DescripcionProducto = 'Leche en polvo descremada La Chacarera <1% grasa',
    @NombreFormula = 'Fórmula LPD Chacarera Light',
    @DescripcionFormula = 'Baja en grasa con alta solubilidad, ideal para mezclas lácteas y dietas especiales.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 13;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 13;


-- 8. Leche en polvo entera El Gauchito 26% grasa
exec usp_insertar_formula_producto
    @CodProducto = 14,
    @IdFormula = 14,

    @DescripcionProducto = 'Leche en polvo entera El Gauchito 26% grasa',
    @NombreFormula = 'Fórmula LPE Gauchito Cremosa',
    @DescripcionFormula = 'Para usos industriales que requieren alta calidad y sabor lácteo intenso.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 14;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 14;

-- 9. Leche en polvo descremada El Bombón <0.8% grasa
exec usp_insertar_formula_producto
    @CodProducto = 15,
    @IdFormula = 15,
    @DescripcionProducto = 'Leche en polvo descremada El Bombón <0.8% grasa',
    @NombreFormula = 'Fórmula LPD Bombón Light',
    @DescripcionFormula = 'Producto con muy bajo contenido graso y buena solubilidad para bebidas lácteas.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 15;

-- 10. Leche en polvo entera La Abuela 25% grasa
exec usp_insertar_formula_producto
    @CodProducto = 16,
    @IdFormula = 16,
    @DescripcionProducto = 'Leche en polvo entera La Abuela 25% grasa',
    @NombreFormula = 'Fórmula LPE Abuela Cremosa',
    @DescripcionFormula = 'Sabor tradicional y textura cremosa, óptima para elaboración de productos lácteos clásicos.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 16;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioPolvos, @IdFormula = 16;


-- 3. Concentrado lácteo evaporado
exec usp_insertar_formula_producto
    @CodProducto = 17,
    @IdFormula = 17,
    @DescripcionProducto = 'Concentrado lácteo evaporado 2x',
    @NombreFormula = 'Fórmula CL-Evaporado 2025',
    @DescripcionFormula = 'Concentración al 50% por evaporación, estabilizado para transporte a granel sin refrigeración.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 17;


-- 4. Concentrado proteico lácteo (CPL)
exec usp_insertar_formula_producto
    @CodProducto = 18,
    @IdFormula = 18,
    @DescripcionProducto = 'Concentrado proteico lácteo 80%',
    @NombreFormula = 'Fórmula CPL-80 Microfiltrado',
    @DescripcionFormula = 'Separación por membrana, 80% proteínas, bajo contenido de lactosa, uso deportivo o nutricional.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 18;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioNYC, @IdFormula = 18;

-- Mas producto tipo dulce de leche para alfajores varios
-- 3. Dulce de leche clásico para untar Rastafari
exec usp_insertar_formula_producto
    @CodProducto = 19,
    @IdFormula = 19,
    @DescripcionProducto = 'Dulce de leche clásico para untar Rastafari',
    @NombreFormula = 'Fórmula DDL Untable Rastafari 2025',
    @DescripcionFormula = 'Textura cremosa, 60% sólidos, color caramelo medio, ideal para untar en alfajores.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 19;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 19;

-- 4. Dulce de leche clásico para untar Habanito
exec usp_insertar_formula_producto
    @CodProducto = 20,
    @IdFormula = 20,
    @DescripcionProducto = 'Dulce de leche clásico para untar Habanito',
    @NombreFormula = 'Fórmula DDL Untable Habanito 2025',
    @DescripcionFormula = 'Suave y dulce, 63% sólidos, color caramelo dorado, pensado para paladares exigentes.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 20;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria02, @IdFormula = 20;

-- 5. Dulce de leche clásico para untar Capitán del Cosmo
exec usp_insertar_formula_producto
    @CodProducto = 21,
    @IdFormula = 21,
    @DescripcionProducto = 'Dulce de leche clásico para untar Capitán del Cosmo',
    @NombreFormula = 'Fórmula DDL Untable Cosmo 2025',
    @DescripcionFormula = 'Fórmula con cuerpo, 61% sólidos, color caramelo oscuro, ideal para untar o rellenar.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 21;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 21;

-- 6. Dulce de leche clásico para untar La Porteña
exec usp_insertar_formula_producto
    @CodProducto = 22,
    @IdFormula = 22,
    @DescripcionProducto = 'Dulce de leche clásico para untar La Porteña',
    @NombreFormula = 'Fórmula DDL Untable Porteña 2025',
    @DescripcionFormula = 'Textura aterciopelada, 62% sólidos, color caramelo claro, para uso gourmet.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 22;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 22;

-------------------

-- 7. Dulce de leche clásico para untar El Correntino
exec usp_insertar_formula_producto
    @CodProducto = 23,
    @IdFormula = 23,
    @DescripcionProducto = 'Dulce de leche clásico para untar El Correntino',
    @NombreFormula = 'Fórmula DDL Untable Correntino 2025',
    @DescripcionFormula = 'Sabor tradicional, 60% sólidos, color caramelo medio, textura cremosa.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 23;

-- 8. Dulce de leche clásico para untar La Ruca
exec usp_insertar_formula_producto
    @CodProducto = 24,
    @IdFormula = 24,
    @DescripcionProducto = 'Dulce de leche clásico para untar La Ruca',
    @NombreFormula = 'Fórmula DDL Untable Ruca 2025',
    @DescripcionFormula = 'Ideal para rellenos, 62% sólidos, color caramelo claro, sabor equilibrado.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 24;

-- 9. Dulce de leche clásico para untar La Chacarera
exec usp_insertar_formula_producto
    @CodProducto = 25,
    @IdFormula = 25,
    @DescripcionProducto = 'Dulce de leche clásico para untar La Chacarera',
    @NombreFormula = 'Fórmula DDL Untable Chacarera 2025',
    @DescripcionFormula = 'Textura firme, 63% sólidos, color caramelo medio, para consumo directo y rellenos.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 25;

-- 10. Dulce de leche clásico para untar El Gauchito
exec usp_insertar_formula_producto
    @CodProducto = 26,
    @IdFormula = 26,
    @DescripcionProducto = 'Dulce de leche clásico para untar El Gauchito',
    @NombreFormula = 'Fórmula DDL Untable Gauchito 2025',
    @DescripcionFormula = 'Sabor intenso, 61% sólidos, color caramelo oscuro, para rellenos premium.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 26;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 26;

-- 11. Dulce de leche clásico para untar El Bombón
exec usp_insertar_formula_producto
    @CodProducto = 27,
    @IdFormula = 27,
    @DescripcionProducto = 'Dulce de leche clásico para untar El Bombón',
    @NombreFormula = 'Fórmula DDL Untable Bombón 2025',
    @DescripcionFormula = 'Cremoso y dulce, 62% sólidos, color caramelo claro, para consumo directo.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 27;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria02, @IdFormula = 27;

-- 12. Dulce de leche clásico para untar La Abuela
exec usp_insertar_formula_producto
    @CodProducto = 28,
    @IdFormula = 28,
    @DescripcionProducto = 'Dulce de leche clásico para untar La Abuela',
    @NombreFormula = 'Fórmula DDL Untable Abuela 2025',
    @DescripcionFormula = 'Textura tradicional, 60% sólidos, color caramelo medio, sabor casero.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 28;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 28;

-- 29. Dulce de leche conito industrial 25kg
exec usp_insertar_formula_producto
    @CodProducto = 29,
    @IdFormula = 29,
    @DescripcionProducto = 'Dulce de leche conito industrial 25kg',
    @NombreFormula = 'Fórmula semidura para modelado 2025',
    @DescripcionFormula = 'Fórmula semidura para modelado, 60% sólidos, color caramelo medio, ideal para productos moldeados.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 29;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 29;

-- 30. Dulce de leche alfajorero estándar 25kg
exec usp_insertar_formula_producto
    @CodProducto = 30,
    @IdFormula = 30,
    @DescripcionProducto = 'Dulce de leche alfajorero estándar 25kg',
    @NombreFormula = 'Fórmula alfajorero estándar 2025',
    @DescripcionFormula = 'Alta viscosidad, 62% sólidos, sabor intenso, pensado para relleno de alfajores.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 30;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 30;

-- 31. Relleno alfajorero tradicional 25kg
exec usp_insertar_formula_producto
    @CodProducto = 31,
    @IdFormula = 31,
    @DescripcionProducto = 'Relleno alfajorero tradicional 25kg',
    @NombreFormula = 'Fórmula relleno tradicional 2025',
    @DescripcionFormula = 'Textura firme y estable, 62.5% sólidos, diseñado para líneas automáticas de relleno.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 31;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 31;

-- 32. Relleno alfajorero tradicional 10kg
exec usp_insertar_formula_producto
    @CodProducto = 32,
    @IdFormula = 32,
    @DescripcionProducto = 'Relleno alfajorero tradicional 10kg',
    @NombreFormula = 'Fórmula relleno tradicional 10kg 2025',
    @DescripcionFormula = 'Mismo perfil que presentación de 25kg, en formato reducido para lotes pequeños o pruebas.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 32;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 32;

-- 33. Dulce de leche familiar balde 4kg
exec usp_insertar_formula_producto
    @CodProducto = 33,
    @IdFormula = 33,
    @DescripcionProducto = 'Dulce de leche familiar balde 4kg',
    @NombreFormula = 'Fórmula familiar balde 2025',
    @DescripcionFormula = 'Consistencia media, 60% sólidos, pensado para fraccionamiento y uso doméstico.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 33;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 33;

-- 34. Dulce de leche repostero pouch 1kg
exec usp_insertar_formula_producto
    @CodProducto = 34,
    @IdFormula = 34,
    @DescripcionProducto = 'Dulce de leche repostero pouch 1kg',
    @NombreFormula = 'Fórmula repostero pouch 2025',
    @DescripcionFormula = 'Textura consistente para decoración y horneado, 63% sólidos, apto para aplicación directa.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 34;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioDulceria01, @IdFormula = 34;

-- Fórmula 35: leche entera, descremada y crema (cada producto separado)
exec usp_insertar_formula_producto
    @CodProducto = 35,  -- código producto leche entera fórmula 1
    @IdFormula = 35,
    @DescripcionProducto = 'Leche entera - fórmula 1',
    @NombreFormula = 'Fórmula leche entera/descremada/crema 1 - 2025',
    @DescripcionFormula = 'Producción separada de leche entera, descremada y crema en la misma línea bajo fórmula 1.';

exec usp_relacionar_usuario_formula @IdUsuario = 1, @IdFormula = 35;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioRecibo, @IdFormula = 35;


-- Fórmula 36: leche entera, descremada y crema (cada producto separado)
exec usp_insertar_formula_producto
    @CodProducto = 36,  -- código producto leche entera fórmula 2
    @IdFormula = 36,
    @DescripcionProducto = 'Leche entera - fórmula 2',
    @NombreFormula = 'Fórmula leche entera/descremada/crema 2 - 2025',
    @DescripcionFormula = 'Producción separada de leche entera, descremada y crema en la misma línea bajo fórmula 2.';

exec usp_relacionar_usuario_formula @IdUsuario = 2, @IdFormula = 36;
exec usp_relacionar_usuario_formula @IdUsuario = @IdUsuarioRecibo, @IdFormula = 36;



go
--QUE FALTA
-- Deposito

-- Obtenemos los IdSector
declare @ReciboId int, @PolvosId int, @DulceriaId int, @NanoId int;

select @ReciboId = IdSector from Sector where Nombre = 'Recibo';
select @PolvosId = IdSector from Sector where Nombre = 'Polvos';
select @DulceriaId = IdSector from Sector where Nombre = 'Dulceria';
select @NanoId = IdSector from Sector where Nombre = 'Nano y Concentrados';

set IDENTITY_INSERT Deposito on;

-- Depósitos sector Recibo (recepción de materia prima láctea)
insert into Deposito (IdDeposito, Nombre, Descripcion, IdSector) values
(1, 'Tanque Leche Cruda 1', 'Tanque de recepción de leche cruda 1', @ReciboId),
(2, 'Tanque Leche Cruda 2', 'Tanque de recepción de leche cruda 2', @ReciboId),
(3, 'Tanque Agua', 'Tanque para agua de proceso', @ReciboId),
(4, 'Tanque Crema', 'Tanque para crema', @ReciboId),
(5, 'Recibo - Depósito General', 'Depósito general de recibo', @ReciboId);

-- Depósitos sector Polvos (almacenamiento de ingredientes en polvo)
insert into Deposito (IdDeposito, Nombre, Descripcion, IdSector) values
(6, 'Silo Leche en Polvo 1', 'Silo para leche en polvo 1', @PolvosId),
(7, 'Silo Leche en Polvo 2', 'Silo para leche en polvo 2', @PolvosId),
(8, 'Silo Suero en Polvo', 'Silo para suero en polvo', @PolvosId),
(9, 'Depósito Aditivos', 'Depósito para aditivos en polvo', @PolvosId),
(10, 'Depósito Envases Polvo', 'Depósito para envases de polvo', @PolvosId),
(11, 'Polvos - Depósito General', 'Depósito general del sector Polvos', @PolvosId);

-- Depósitos sector Dulcería (almacenamiento y proceso de productos dulces lácteos)
insert into Deposito (IdDeposito, Nombre, Descripcion, IdSector) values
(12, 'Depósito Azúcar', 'Depósito de azúcar para dulcería', @DulceriaId),
(13, 'Tanque Jarabe', 'Tanque para jarabes', @DulceriaId),
(14, 'Depósito Saborizantes', 'Depósito para saborizantes', @DulceriaId),
(15, 'Depósito Empaques Dulces 1', 'Depósito de empaques para dulces 1', @DulceriaId),
(16, 'Depósito Empaques Dulces 2', 'Depósito de empaques para dulces 2', @DulceriaId),
(17, 'Dulcería - Depósito General', 'Depósito general del sector Dulcería', @DulceriaId);

-- Depósitos sector Nano y Concentrados (almacenamiento de productos concentrados y nano)
insert into Deposito (IdDeposito, Nombre, Descripcion, IdSector) values
(18, 'Tanque Concentrado Proteico', 'Tanque para concentrado proteico', @NanoId),
(19, 'Tanque Concentrado Grasa 1', 'Tanque para concentrado de grasa', @NanoId),
(20, 'Tanque Concentrado Grasa 2', 'Tanque para concentrado de grasa', @NanoId),
(21, 'Depósito Nano Partículas', 'Depósito para nano partículas', @NanoId),
(22, 'Depósito Ingredientes Activos', 'Depósito para ingredientes activos', @NanoId),
(23, 'Depósito Envases Concentrados', 'Depósito para envases de concentrados', @NanoId),
(24, 'Nano - Depósito General', 'Depósito general del sector Nano y Concentrados', @NanoId);

set IDENTITY_INSERT Deposito off;
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
('CA', 'Caja de productos'),
('CA25KG', 'Caja de productos 25KG'),
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
(93, 'Caja wrap around 6 x 800 g marrón lisa'),
(94, 'Leche cruda proveniente de Tambo');



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

-- Crear TAMBOS para insumo recibo
insert into Proveedor (IdProveedor, Nombre, Calle, Nro, Localidad) values
(29, 'Estancia La Esperanza', 'Ruta 41', 'km 45', 'San Miguel del Monte'),
(30, 'Tambo El Amanecer', 'Acceso Este', '750', 'Chivilcoy'),
(31, 'Granja Don Alberto', 'Camino a Navarro', '2300', 'Mercedes'),
(32, 'Tambo San Benito', 'Ruta 3', 'km 112', 'Cañuelas'),
(33, 'Tambo Los Hermanos', 'Calle Rural 8', '450', 'Suipacha'),
(34, 'Establecimiento La Emilia', 'Camino Provincial 31', '890', 'Roque Pérez'),
(35, 'Tambo El Progreso', 'Callejón El Ombú', '1150', 'San Andrés de Giles'),
(36, 'Granja San Miguel', 'Ruta 205', 'km 88', 'Monte'),
(37, 'Tambo Don Juan', 'Av. La Tradición', '321', 'Luján'),
(38, 'Estancia Los Robles', 'Ruta 6', 'km 70', 'General Rodríguez'),
(39, 'Tambo La Querencia', 'Camino del Medio', '1980', 'Brandsen'),
(40, 'Tambo Santa Clara', 'Camino Rural 5', '1200', 'Lobos');


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


-- AHORA VENDRIA
-- OrdenCompra
-- MovimientoCompra
-- MovimientoStock

-- Si hago una orden de compra a la vez crea unos detalles (movimiento de Entrega)

--usp_insertar_orden_compra_con_movimientos ''

if not exists (select * from sys.types where name = 'TVP_CompraItem')
begin
    create type TVP_CompraItem as table (
        CodProducto int,
        Cantidad decimal(15,2),
        FechaVencimiento datetime,
        FechaMovimiento datetime,
        IdDeposito int,
        IdUM int,
        PrecioUnitario decimal(18,2)
    );
end
go

create or alter procedure usp_insertar_orden_compra_con_movimientos
    @IdProveedor int,
    @IdUsuario int,
    @EstadoOC nvarchar(50),
    @FechaCompra datetime = null,
    @Items TVP_CompraItem readonly
as
begin
    set nocount on;

    declare @IdEstadoOC int;
    select @IdEstadoOC = IdEstadoOC from EstadoOC where Nombre = @EstadoOC;

    if @IdEstadoOC is null
    begin
        raiserror('Estado de orden de compra no válido.', 16, 1);
        return;
    end

    insert into OrdenCompra (IdProveedor, IdUsuario, IdEstadoOC, FechaCompra)
    values (@IdProveedor, @IdUsuario, @IdEstadoOC, coalesce(@FechaCompra, getdate()));

    declare @NroCompra int = scope_identity();

    declare @CodProducto int, @Cantidad decimal(15,2), @FechaVencimiento datetime,
            @FechaMovimiento datetime,  -- agregada variable
            @IdDeposito int, @IdUM int, @PrecioUnitario decimal(18,2),
            @TipoMovimiento varchar(7);

    declare item_cursor cursor for
        select CodProducto, Cantidad, FechaVencimiento, FechaMovimiento, IdDeposito, IdUM, PrecioUnitario
        from @Items;

    open item_cursor;
    fetch next from item_cursor into @CodProducto, @Cantidad, @FechaVencimiento, @FechaMovimiento, @IdDeposito, @IdUM, @PrecioUnitario;

    while @@fetch_status = 0
    begin
        set @TipoMovimiento = case when @EstadoOC = 'Solicitada' then 'Espera' else 'Ingreso' end;

        insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
        values (@CodProducto, @IdDeposito, @IdUM, @FechaVencimiento, @FechaMovimiento, @TipoMovimiento, @Cantidad);

        declare @IdMovimiento int = scope_identity();

        insert into MovimientoCompra (IdMovimiento, NroCompra, PrecioUnitario)
        values (@IdMovimiento, @NroCompra, @PrecioUnitario);

        fetch next from item_cursor into @CodProducto, @Cantidad, @FechaVencimiento, @FechaMovimiento, @IdDeposito, @IdUM, @PrecioUnitario;
    end

    close item_cursor;
    deallocate item_cursor;
end
go


declare @Items TVP_CompraItem;

insert into @Items (CodProducto, Cantidad, FechaVencimiento, FechaMovimiento, IdDeposito, IdUM, PrecioUnitario)
values
(51, 100, '2026-08-01', DATEADD(day, -30, GETDATE()), 10, 1, 4200),  -- Bolsas de papel, hace 30 días
(54, 300, '2026-10-01', DATEADD(day, -25, GETDATE()), 10, 1, 1900),  -- Film stretch, hace 25 días
(55, 250, '2026-06-22', DATEADD(day, -20, GETDATE()), 10, 1, 5100);  -- Bolsas aluminizadas, hace 20 días


exec usp_insertar_orden_compra_con_movimientos
    @IdProveedor = 4,               -- Envaflex Industrial
    @IdUsuario = 2,                 -- Usuario comprador
    @EstadoOC = 'Recibida',        -- Si fuera 'Solicitada', se registrarían como 'Ingreso'
    @Items = @Items;


go

-- variables de sectores (debes tener esta tabla Sector con estos nombres)
declare @ReciboId int, @PolvosId int, @DulceriaId int, @NanoId int;

select @ReciboId = IdSector from Sector where Nombre = 'Recibo';
select @PolvosId = IdSector from Sector where Nombre = 'Polvos';
select @DulceriaId = IdSector from Sector where Nombre = 'Dulceria';
select @NanoId = IdSector from Sector where Nombre = 'Nano y Concentrados';

-- tabla temporal con productos, depósitos, precio base, proveedor y sector
declare @Productos table (
    CodProducto int,
    IdDeposito int,
    PrecioBase decimal(18,2),
    IdProveedor int,
    IdSector int
);

-- insertar productos con sector asignado según depósito, sin sectores indefinidos
insert into @Productos (CodProducto, IdDeposito, PrecioBase, IdProveedor, IdSector)
values
(51, 10, 4200, 11, @PolvosId), -- Bolsa de papel Kraft multicapa 25 kg (Multicapas del Litoral S.A.)
(52, 5, 1500, 9, @ReciboId), -- Separadores de cartón para filas de 5 bolsas (Cartonpack Argentina S.R.L.)
(53, 5, 1800, 5, @ReciboId), -- Esquineros de cartón para protección estructural (Cartonería del Centro S.A.)
(54, 10, 1900, 10, @PolvosId), -- Film stretch para inmovilizar carga (Zonda Films y Empaques S.R.L.)
(55, 10, 5100, 4, @PolvosId), -- Bolsa de papel aluminizado trilaminada 800 g (Envaflex Industrial S.A.)
(56, 5, 2500, 16, @ReciboId), -- Caja máster corrugada para 7 bolsas (Corrugados del Sur S.A.)
(57, 5, 1400, 5, @ReciboId), -- Separadores de cartón internos (Cartonería del Centro S.A.)
(58, 13, 3000, 13, @DulceriaId), -- Etiquetas con datos nutricionales (SelloSeguro S.R.L.)
(59, 15, 3500, 15, @DulceriaId), -- Etiquetas RFID para trazabilidad logística (TecniGlass Empaques S.A.)
(60, 12, 2800, 12, @DulceriaId), -- Caja con recubrimiento antihumedad interno (EcoPacking Solutions S.A.)
(61, 6, 3100, 16, @PolvosId), -- Caja máster para leche en polvo 400 g (Corrugados del Sur S.A.)
(62, 7, 3200, 16, @PolvosId), -- Caja máster para leche en polvo 800 g (Corrugados del Sur S.A.)
(63, 21, 4000, 21, @NanoId), -- Bolsa para leche entera sin impresión 53x92x14 cm (Bolsaflex Industrial S.A.)
(64, 21, 4200, 5, @NanoId), -- Bolsa para suero en polvo con impresión 53x97x14 cm (TecnoEnvases SRL)
(65, 21, 4100, 5, @NanoId), -- Bolsa para polvo con impresión 53x97x14 cm (TecnoEnvases SRL)
(66, 9, 1600, 9, @PolvosId), -- Separador para palletizar 1x1.20 mts (Cartonpack Argentina S.R.L.)
(67, 13, 2900, 13, @DulceriaId), -- Termoetiqueta 58x43 mm cono 70 (SelloSeguro S.R.L.)
(68, 3, 4500, 5, @ReciboId), -- Pallets de madera estandarizados (Grupo Barriopack S.A.)
(69, 10, 1950, 10, @PolvosId), -- Film stretch para pallets (Zonda Films y Empaques S.R.L.)
(70, 22, 1200, 22, @NanoId), -- Hipoclorito de sodio al 100% (Química Pampeana S.A.)
(71, 22, 1100, 22, @NanoId), -- Producto de limpieza industrial (Deptacid NT) (Química Pampeana S.A.)
(72, 22, 1300, 22, @NanoId), -- Soda cáustica (hidróxido de sodio) (Química Pampeana S.A.)
(73, 12, 2500, 12, @DulceriaId), -- Recupero de gruesos polvos (EcoPacking Solutions S.A.)
(74, 9, 1500, 9, @PolvosId), -- Separadores de cartón para cajas (Cartonpack Argentina S.R.L.)
(75, 19, 2700, 19, @NanoId), -- Cinta de seguridad industrial (Precintados La Esperanza S.R.L.)
(76, 23, 6000, 23, @NanoId), -- Envase plástico para dulce de leche 400 g (fit) (PlastiPack SRL)
(77, 23, 6100, 23, @NanoId), -- Envase plástico para dulce de leche 400 g (repostero) (PlastiPack SRL)
(78, 23, 6200, 23, @NanoId), -- Envase plástico para dulce de leche 1 kg (repostero) (PlastiPack SRL)
(79, 24, 2200, 24, @NanoId), -- Tapa de aluminio para envase plástico 1 kg (AluTapas Argentina S.A.)
(80, 13, 3100, 13, @DulceriaId), -- Etiqueta para dulce de leche 450 g (SelloSeguro S.R.L.)
(81, 23, 6300, 23, @NanoId), -- Envase plástico para dulce de leche 1 kg (familiar) (PlastiPack SRL)
(82, 5, 1400, 5, @ReciboId), -- Caja cartón para 6 envases de 1 kg dulce de leche (Cartonería del Centro S.A.)
(88, 9, 1300, 9, @PolvosId), -- Separadores antideslizantes 1200x1000 mm (Cartonpack Argentina S.R.L.)
(90, 22, 1400, 22, @NanoId), -- Dióxido de titanio (Química Pampeana S.A.)
(91, 23, 6400, 23, @NanoId), -- Envase plástico 4 kg blanco sin impresión (PlastiPack SRL)
(92, 12, 2600, 12, @DulceriaId), -- Recupero dulce relleno (EcoPacking Solutions S.A.)
(93, 16, 1500, 16, @PolvosId); -- Caja wrap around 6 x 800 g marrón lisa (Corrugados del Sur S.A.)

declare @I int = 1;
declare @Max int = 100;

while @I <= @Max
begin
    declare @Items tvp_compraitem;

    declare @IdUsuario int = 2 + cast(rand(checksum(newid())) * 7 as int);
    declare @EstadoOC nvarchar(50) = case when @I % 2 = 0 then 'Solicitada' else 'Recibida' end;
    declare @CantItems int = 3 + cast(rand(checksum(newid())) * 4 as int);

    -- Generar fecha de compra aleatoria entre 01/01/2020 y hoy
    declare @FechaInicio datetime = '2020-01-01';
    declare @FechaFin datetime = getdate();
    declare @DiasTotal int = datediff(day, @FechaInicio, @FechaFin);
    declare @DiasRandom int = cast(rand(checksum(newid())) * @DiasTotal as int);
    declare @FechaCompra datetime = dateadd(day, @DiasRandom, @FechaInicio);

    declare @ProdIndex int = 1;

    while @ProdIndex <= @CantItems
    begin
        declare 
            @CodProducto int, 
            @IdDeposito int, 
            @PrecioBase decimal(18,2), 
            @IdProveedor int;

        select top 1 
            @CodProducto = CodProducto, 
            @IdDeposito = IdDeposito, 
            @PrecioBase = PrecioBase, 
            @IdProveedor = IdProveedor
        from @Productos
        order by newid();

        declare @Cantidad decimal(15,2) = round(50 + rand(checksum(newid())) * 200, 2);
        declare @PrecioUnitario decimal(18,2) = round(@PrecioBase * (0.9 + rand(checksum(newid())) * 0.2), 2);

        declare @FechaMovimiento datetime = @FechaCompra;
        declare @FechaVencimiento datetime = dateadd(day, 150 + cast(rand(checksum(newid())) * 60 as int), getdate());



        insert into @Items (
            CodProducto, Cantidad, FechaVencimiento, FechaMovimiento, IdDeposito, IdUM, PrecioUnitario
        )
        values (
            @CodProducto, @Cantidad, @FechaVencimiento, @FechaMovimiento, @IdDeposito, 1, @PrecioUnitario
        );

        set @ProdIndex += 1;
    end

    declare @IdProveedorSeleccionado int;
    select top 1 @IdProveedorSeleccionado = p.IdProveedor
    from @Items i
    join @Productos p on i.CodProducto = p.CodProducto;

    exec usp_insertar_orden_compra_con_movimientos
        @IdProveedor = @IdProveedorSeleccionado,
        @IdUsuario = @IdUsuario,
        @EstadoOC = @EstadoOC,
        @FechaCompra = @FechaCompra,
        @Items = @Items;

    set @I += 1;
end
go



declare @ReciboId int, @PolvosId int, @DulceriaId int, @NanoId int;

select @ReciboId = IdSector from Sector where Nombre = 'Recibo';
select @PolvosId = IdSector from Sector where Nombre = 'Polvos';
select @DulceriaId = IdSector from Sector where Nombre = 'Dulceria';
select @NanoId = IdSector from Sector where Nombre = 'Nano y Concentrados';

-- tabla temporal con productos, depósitos, precio base, proveedor y sector
declare @Productos table (
    CodProducto int,
    IdDeposito int,
    PrecioBase decimal(18,2),
    IdProveedor int,
    IdSector int
);

-- Más leche cruda de tambos bonaerenses
insert into @Productos (CodProducto, IdDeposito, PrecioBase, IdProveedor, IdSector)
values
(94, 2, 1060.32, 40, @ReciboId),
(94, 1, 1370.45, 29, @ReciboId),
(94, 1, 1200.89, 30, @ReciboId),
(94, 2, 1110.15, 31, @ReciboId),
(94, 1, 1470.62, 32, @ReciboId),
(94, 2, 1010.77, 33, @ReciboId),
(94, 1, 1290.34, 34, @ReciboId),
(94, 2, 1410.99, 35, @ReciboId),
(94, 2, 979.88, 36, @ReciboId),
(94, 1, 1080.76, 37, @ReciboId),
(94, 2, 1198.24, 38, @ReciboId),
(94, 1, 1347.68, 39, @ReciboId),
(94, 1, 1456.21, 40, @ReciboId),
(94, 2, 1237.89, 29, @ReciboId),
(94, 1, 1135.05, 30, @ReciboId),
(94, 2, 1305.92, 31, @ReciboId),
(94, 2, 1188.44, 32, @ReciboId),
(94, 1, 1245.55, 33, @ReciboId),
(94, 2, 1277.73, 34, @ReciboId),
(94, 1, 1325.19, 35, @ReciboId),
(94, 1, 1407.03, 36, @ReciboId),
(94, 2, 1154.67, 37, @ReciboId),
(94, 2, 1224.78, 38, @ReciboId),
(94, 1, 1396.50, 39, @ReciboId),
(94, 2, 897.10, 40, @ReciboId),
(94, 1, 1654.50, 29, @ReciboId),
(94, 2, 8247.30, 30, @ReciboId),
(94, 1, 1974.80, 31, @ReciboId),
(94, 2, 1034.45, 32, @ReciboId),
(94, 1, 1428.90, 33, @ReciboId),
(94, 2, 2085.75, 34, @ReciboId),
(94, 1, 936.60, 35, @ReciboId),
(94, 1, 1857.20, 36, @ReciboId),
(94, 2, 995.99, 37, @ReciboId),
(94, 2, 1144.70, 38, @ReciboId),
(94, 1, 122.85, 39, @ReciboId),
(94, 2, 9146.45, 40, @ReciboId),
(94, 1, 1454.30, 29, @ReciboId),
(94, 2, 1374.00, 30, @ReciboId),
(94, 1, 1604.00, 31, @ReciboId),
(94, 2, 1004.00, 32, @ReciboId),
(94, 1, 1884.88, 33, @ReciboId),
(94, 2, 1294.40, 34, @ReciboId),
(94, 1, 1514.51, 35, @ReciboId),
(94, 2, 804.00, 36, @ReciboId),
(94, 1, 1714.15, 37, @ReciboId),
(94, 2, 1384.90, 38, @ReciboId),
(94, 1, 1994.99, 39, @ReciboId);

declare @I int = 1;
declare @Max int = 100;

while @I <= @Max
begin
    declare @Items tvp_compraitem;

    declare @IdUsuario int = 2 + cast(rand(checksum(newid())) * 7 as int);
    declare @EstadoOC nvarchar(50) = case when @I % 2 = 0 then 'Solicitada' else 'Recibida' end;
    declare @CantItems int = 3 + cast(rand(checksum(newid())) * 4 as int);

    declare @FechaInicio datetime = '2020-01-01';
    declare @FechaFin datetime = getdate();
    declare @DiasTotal int = datediff(day, @FechaInicio, @FechaFin);
    declare @DiasRandom int = cast(rand(checksum(newid())) * @DiasTotal as int);
    declare @FechaCompra datetime = dateadd(day, @DiasRandom, @FechaInicio);

    declare @ProdIndex int = 1;

    while @ProdIndex <= @CantItems
    begin
        declare 
            @CodProducto int, 
            @IdDeposito int, 
            @PrecioBase decimal(18,2), 
            @IdProveedor int;

        select top 1 
            @CodProducto = CodProducto, 
            @IdDeposito = IdDeposito, 
            @PrecioBase = PrecioBase, 
            @IdProveedor = IdProveedor
        from @Productos
        order by newid();

        declare @Cantidad decimal(15,2) = round(50 + rand(checksum(newid())) * 20000, 2);
        declare @PrecioUnitario decimal(18,2) = round(@PrecioBase * (0.9 + rand(checksum(newid())) * 0.2), 2);

        declare @FechaMovimiento datetime = @FechaCompra;
        declare @FechaVencimiento datetime = dateadd(hour, 96, @FechaMovimiento);

        declare @IdUM int;
        select @IdUM =  IdUM from UnidadMedida where Nombre = 'LT';

        insert into @Items (CodProducto, Cantidad, FechaVencimiento, FechaMovimiento, IdDeposito, IdUM, PrecioUnitario)
        values (@CodProducto, @Cantidad, @FechaVencimiento, @FechaMovimiento, @IdDeposito, @IdUM, @PrecioUnitario);

        set @ProdIndex += 1;
    end

    declare @IdProveedorSeleccionado int;
    select top 1 @IdProveedorSeleccionado = p.IdProveedor
    from @Items i
    join @Productos p on i.CodProducto = p.CodProducto
    order by newid();

    exec usp_insertar_orden_compra_con_movimientos
        @IdProveedor = @IdProveedorSeleccionado,
        @IdUsuario = @IdUsuario,
        @EstadoOC = @EstadoOC,
        @FechaCompra = @FechaCompra,
        @Items = @Items;

    set @I += 1;
end
go


-- LO PROXIMO ES ORDENES DE FABRICACION
-- Primero se tendria que tener leche cruda. Que se recibe. (No se si ponerlo en compra)
-- 

-- GRAN CANTIDAD DE STOCK DE TODO



-- -- LOS JEFES Y SUPERVISORES:
-- -- JefeRecibo
-- select u.IdUsuario
-- into #JefeRecibo
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'JefeRecibo';

-- -- SupervisorRecibo
-- select u.IdUsuario
-- into #SupervisorRecibo
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'SupervisorRecibo';

-- -- JefePolvos
-- select u.IdUsuario
-- into #JefePolvos
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'JefePolvos';

-- -- SupervisorPolvos
-- select u.IdUsuario
-- into #SupervisorPolvos
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'SupervisorPolvos';

-- -- JefeDulceria
-- select u.IdUsuario
-- into #JefeDulceria
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'JefeDulceria';

-- -- SupervisorDulceria
-- select u.IdUsuario
-- into #SupervisorDulceria
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'SupervisorDulceria';

-- -- JefeNanoYConcentrados
-- select u.IdUsuario
-- into #JefeNanoYConcentrados
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'JefeNanoYConcentrados';

-- -- SupervisorNanoYConcentrados
-- select u.IdUsuario
-- into #SupervisorNanoYConcentrados
-- from Usuario u
-- inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
-- inner join Rol r on ur.IdRol = r.IdRol
-- where r.Nombre = 'SupervisorNanoYConcentrados';

-- go

-- Lista de tablas temporales
-- #JefeRecibo, #SupervisorRecibo, #JefePolvos, #SupervisorPolvos, #JefeDulceria, #SupervisorDulceria, #JefeNanoYConcentrados, #SupervisorNanoYConcentrados

-- Linea para recibo


-- tambos del 29 al 40


-- Falta poner unidad medida Listros en tambos
-- Las cantidades son muy pequeñas . 20000 litros  procesa 3000000 mil por litro


-- CREAR LINEAS GENERICAS

-- Obtener los IdSector
declare @IdSectorRecibo int = (select IdSector from Sector where Nombre = 'Recibo');
declare @IdSectorPolvos int = (select IdSector from Sector where Nombre = 'Polvos');
declare @IdSectorDulceria int = (select IdSector from Sector where Nombre = 'Dulceria');
declare @IdSectorNano int = (select IdSector from Sector where Nombre = 'Nano y Concentrados');

-- Habilitar IDENTITY_INSERT
set identity_insert Linea on;

insert into Linea (IdLinea, IdSector, Nombre, Descripcion)
values
-- 1 línea para Recibo
(1, @IdSectorRecibo, 'Recibo Principal', 'Línea principal recibo'),

-- 2 líneas para Polvos
(2, @IdSectorPolvos, 'Secado Torre 1', 'Línea de polvos 1'),
(3, @IdSectorPolvos, 'Secado Torre 2', 'Línea de polvos 2'),

-- 3 líneas para Dulcería
(4, @IdSectorDulceria, 'Dulce Línea 1', 'Producción de dulce 1'),
(5, @IdSectorDulceria, 'Dulce Línea 2', 'Producción de dulce 2'),
(6, @IdSectorDulceria, 'Dulce Línea 3', 'Producción de dulce 3'),

-- 2 líneas para Nano y Concentrados
(7, @IdSectorNano, 'Nano Proceso 1', 'Nano 1'),
(8, @IdSectorNano, 'Concentrado 1', 'Nano 2');

-- Deshabilitar IDENTITY_INSERT
set identity_insert Linea off;
go


----------------------------
----------------------------
----------------------------

create or alter procedure usp_simular_proceso_leche_completo
    @IdProveedor int, -- 29 a 40
    @CodProdLecheCruda int, -- 94
    @CodProdEntera int, -- 35 o 36
    @CodProdDescremada int, -- 35 o 36
    @CodProdCrema int, --35 o 36
    @CodProdPolvo int, -- 8, 10, 12, 14 o 16 
    @CodProdPolvoDescremada int, -- 9, 11, 13 o 15  
    @IdDepositoRecibo int, -- 1 a 4
    @IdDepositoSecado int, -- 6 a 8
    @IdLinea1 int, -- 1 
    @IdLinea2 int, -- 2 
    @IdLinea3 int, -- 3
    @IdFormula1 int, -- 35 o 36
    @IdFormula2 int, -- 8, 10, 12, 14, 16 
    @IdFormula3 int, -- 9, 11, 13 o 15  
    @CantidadCruda decimal(15,2), -- debe ser mayor a la suma de las otras cantidades, de 20000 a 50000
    @CantidadEntera decimal(15,2),
    @CantidadDescremada decimal(15,2),
    @CantidadCrema decimal(15,2),
    @CantidadPolvo decimal(15,2),
    @CantidadPolvoDescremada decimal(15,2), 
    @PrecioUnitario decimal(18,2), -- de 100 a 5000
    @FechaMovimiento datetime, -- tiene que ser desde el 2020 hasta la actualidad
    @FechaVencimiento datetime, -- 1 a 3 meses despues de FechaMovimiento
    @IdEstadoOC int, --'Solicitada', 'Recibida'
    @IdEstadoOF1 int, -- 'Planificado', 'En Proceso', 'Cerrado', 'Calidad'
    @IdEstadoOF2 int, -- 'Planificado', 'En Proceso', 'Cerrado', 'Calidad'
    @IdEstadoOF3 int -- 'Planificado', 'En Proceso', 'Cerrado', 'Calidad'
as
begin
    set nocount on;

    select u.IdUsuario
    into #JefeRecibo
    from Usuario u
    inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
    inner join Rol r on ur.IdRol = r.IdRol
    where r.Nombre = 'JefeRecibo';

    -- SupervisorRecibo
    select u.IdUsuario
    into #SupervisorRecibo
    from Usuario u
    inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
    inner join Rol r on ur.IdRol = r.IdRol
    where r.Nombre = 'SupervisorRecibo';

    -- JefePolvos
    select u.IdUsuario
    into #JefePolvos
    from Usuario u
    inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
    inner join Rol r on ur.IdRol = r.IdRol
    where r.Nombre = 'JefePolvos';

    -- SupervisorPolvos
    select u.IdUsuario
    into #SupervisorPolvos
    from Usuario u
    inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
    inner join Rol r on ur.IdRol = r.IdRol
    where r.Nombre = 'SupervisorPolvos';

    declare @IdUM int = (select IdUM from UnidadMedida where Nombre = 'LT');

    ----------------------
    -- 1. ORDEN DE COMPRA
    ----------------------

    declare @IdUsuarioOC int = (
        select top 1 IdUsuario from Usuario where IdUsuario between 2 and 8 order by newid()
    );

    insert into OrdenCompra (IdProveedor, IdUsuario, IdEstadoOC)
    values (@IdProveedor, @IdUsuarioOC, @IdEstadoOC);

    declare @NroCompra int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdLecheCruda, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadCruda);

    declare @IdMovimientoCompra int = scope_identity();

    insert into MovimientoCompra (IdMovimiento, NroCompra, PrecioUnitario)
    values (@IdMovimientoCompra, @NroCompra, @PrecioUnitario);

    -------------------------------------------------------------
    -- 2. ORDEN DE FABRICACIÓN - CRUDA → ENTERA/DESCREMADA/CREMA
    -------------------------------------------------------------

    declare @IdUsuarioOF1 int = (
        select top 1 IdUsuario from (
            select IdUsuario from #JefeRecibo
            union all
            select IdUsuario from #SupervisorRecibo
        ) as Recibo order by newid()
    );

    insert into OrdenFabricacion (IdFormula, IdLinea, IdEstadoOF, IdUsuario)
    values (@IdFormula1, @IdLinea1, @IdEstadoOF1, @IdUsuarioOF1);

    declare @NroFabricacion1 int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdLecheCruda, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Egreso', -@CantidadCruda);

    declare @IdMovNeg1 int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovNeg1, @NroFabricacion1, 'Venta', 'Requiere');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdEntera, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadEntera);

    declare @IdMovEnt int = scope_identity();
    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovEnt, @NroFabricacion1, 'Venta', 'Transferencia Directa');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdDescremada, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadDescremada);

    declare @IdMovDesc int = scope_identity();
    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovDesc, @NroFabricacion1, 'Venta', 'Transferencia Directa');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdCrema, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadCrema);

    declare @IdMovCrema int = scope_identity();
    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovCrema, @NroFabricacion1, 'Venta', 'Transferencia Directa');

    -------------------------------------------------------------
    -- 3. ORDEN DE FABRICACIÓN - ENTERA → POLVO ENTERA
    -------------------------------------------------------------

    declare @IdUsuarioOF2 int = (
        select top 1 IdUsuario from (
            select IdUsuario from #JefePolvos
            union all
            select IdUsuario from #SupervisorPolvos
        ) as Polvos order by newid()
    );

    insert into OrdenFabricacion (IdFormula, IdLinea, IdEstadoOF, IdUsuario)
    values (@IdFormula2, @IdLinea2, @IdEstadoOF2, @IdUsuarioOF2);

    declare @NroFabricacion2 int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdEntera, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Egreso', -@CantidadEntera);

    declare @IdMovNeg2 int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovNeg2, @NroFabricacion2, 'Venta', 'Requiere');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdPolvo, @IdDepositoSecado, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadPolvo);

    declare @IdMovPolvo int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovPolvo, @NroFabricacion2, 'Venta', 'Transferencia Directa');

    ---------------------------------------------------------------------
    -- 4. ORDEN DE FABRICACIÓN - DESCREMADA → POLVO DESCREMADA
    ---------------------------------------------------------------------

    declare @IdUsuarioOF3 int = (
        select top 1 IdUsuario from (
            select IdUsuario from #JefePolvos
            union all
            select IdUsuario from #SupervisorPolvos
        ) as Polvos order by newid()
    );

    insert into OrdenFabricacion (IdFormula, IdLinea, IdEstadoOF, IdUsuario)
    values (@IdFormula3, @IdLinea3, @IdEstadoOF3, @IdUsuarioOF3);

    declare @NroFabricacion3 int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdDescremada, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Egreso', -@CantidadDescremada);

    declare @IdMovNeg3 int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovNeg3, @NroFabricacion3, 'Venta', 'Requiere');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdPolvoDescremada, @IdDepositoSecado, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadPolvoDescremada);

    declare @IdMovPolvoDesc int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovPolvoDesc, @NroFabricacion3, 'Venta', 'Transferencia Directa');
end;
go



----------------------------- INICO SCRIPT PYTHON

-- import random
-- from datetime import datetime, timedelta

-- # Configuración
-- CANTIDAD = 5000  # Cambiá este número para generar más o menos EXEC

-- def fecha_random(inicio, fin):
--     return inicio + timedelta(days=random.randint(0, (fin - inicio).days))

-- def fecha_vencimiento(fecha_mov):
--     return fecha_mov + timedelta(days=random.randint(30, 90))

-- fecha_inicio = datetime(2020, 1, 1)
-- fecha_hoy = datetime(2025, 6, 5)

-- def generar_exec():
--     p = {
--         "IdProveedor": random.randint(29, 40),
--         "CodProdLecheCruda": 94,
--         "CodProdEntera": random.choice([35, 36]),
--         "CodProdDescremada": random.choice([35, 36]),
--         "CodProdCrema": random.choice([35, 36]),
--         "CodProdPolvo": random.choice([8, 10, 12, 14, 16]),
--         "CodProdPolvoDescremada": random.choice([9, 11, 13, 15]),
--         "IdDepositoRecibo": random.randint(1, 4),
--         "IdDepositoSecado": random.randint(6, 8),
--         "IdLinea1": 1,
--         "IdLinea2": 2,
--         "IdLinea3": 3,
--         "IdFormula1": random.choice([35, 36]),
--         "IdFormula2": random.choice([8, 10, 12, 14, 16]),
--         "IdFormula3": random.choice([9, 11, 13, 15]),
--         "CantidadEntera": round(random.uniform(5000, 10000), 2),
--         "CantidadDescremada": round(random.uniform(4000, 9000), 2),
--         "CantidadCrema": round(random.uniform(1000, 3000), 2),
--         "CantidadPolvo": round(random.uniform(1000, 5000), 2),
--         "CantidadPolvoDescremada": round(random.uniform(800, 4000), 2),
--         "PrecioUnitario": round(random.uniform(100, 5000), 2),
--         "IdEstadoOC": random.randint(1, 2),
--         "IdEstadoOF1": random.randint(1, 4),
--         "IdEstadoOF2": random.randint(1, 4),
--         "IdEstadoOF3": random.randint(1, 4),
--     }

--     suma_total = sum([
--         p["CantidadEntera"],
--         p["CantidadDescremada"],
--         p["CantidadCrema"],
--         p["CantidadPolvo"],
--         p["CantidadPolvoDescremada"],
--     ])
--     p["CantidadCruda"] = round(suma_total + random.uniform(500, 2000), 2)
--     p["FechaMovimiento"] = fecha_random(fecha_inicio, fecha_hoy)
--     p["FechaVencimiento"] = fecha_vencimiento(p["FechaMovimiento"])

--     fmov = p["FechaMovimiento"].strftime("'%Y-%m-%d'")
--     fven = p["FechaVencimiento"].strftime("'%Y-%m-%d'")

--     return (
--         f"exec usp_simular_proceso_leche_completo "
--         f"@IdProveedor = {p['IdProveedor']}, "
--         f"@CodProdLecheCruda = {p['CodProdLecheCruda']}, "
--         f"@CodProdEntera = {p['CodProdEntera']}, "
--         f"@CodProdDescremada = {p['CodProdDescremada']}, "
--         f"@CodProdCrema = {p['CodProdCrema']}, "
--         f"@CodProdPolvo = {p['CodProdPolvo']}, "
--         f"@CodProdPolvoDescremada = {p['CodProdPolvoDescremada']}, "
--         f"@IdDepositoRecibo = {p['IdDepositoRecibo']}, "
--         f"@IdDepositoSecado = {p['IdDepositoSecado']}, "
--         f"@IdLinea1 = {p['IdLinea1']}, "
--         f"@IdLinea2 = {p['IdLinea2']}, "
--         f"@IdLinea3 = {p['IdLinea3']}, "
--         f"@IdFormula1 = {p['IdFormula1']}, "
--         f"@IdFormula2 = {p['IdFormula2']}, "
--         f"@IdFormula3 = {p['IdFormula3']}, "
--         f"@CantidadCruda = {p['CantidadCruda']}, "
--         f"@CantidadEntera = {p['CantidadEntera']}, "
--         f"@CantidadDescremada = {p['CantidadDescremada']}, "
--         f"@CantidadCrema = {p['CantidadCrema']}, "
--         f"@CantidadPolvo = {p['CantidadPolvo']}, "
--         f"@CantidadPolvoDescremada = {p['CantidadPolvoDescremada']}, "
--         f"@PrecioUnitario = {p['PrecioUnitario']}, "
--         f"@FechaMovimiento = {fmov}, "
--         f"@FechaVencimiento = {fven}, "
--         f"@IdEstadoOC = {p['IdEstadoOC']}, "
--         f"@IdEstadoOF1 = {p['IdEstadoOF1']}, "
--         f"@IdEstadoOF2 = {p['IdEstadoOF2']}, "
--         f"@IdEstadoOF3 = {p['IdEstadoOF3']};"
--     )

-- # Guardar en archivo .sql
-- with open("simular_proceso_leche.sql", "w", encoding="utf-8") as f:
--     for _ in range(CANTIDAD):
--         f.write(generar_exec() + "\n")

-- print(f"Generado archivo con {CANTIDAD} instrucciones exec.")

-- EXEC DEVUELVOS POR SCRIPT --->>


exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 16, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 1, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 13, @CantidadCruda = 19160.17, @CantidadEntera = 5603.07, @CantidadDescremada = 5081.15, @CantidadCrema = 2840.84, @CantidadPolvo = 1302.49, @CantidadPolvoDescremada = 2638.12, @PrecioUnitario = 2140.92, @FechaMovimiento = '2023-09-01', @FechaVencimiento = '2023-11-11', @IdEstadoOC = 1, @IdEstadoOF1 = 4, @IdEstadoOF2 = 4, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 37, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 8, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 14, @IdFormula3 = 11, @CantidadCruda = 19149.01, @CantidadEntera = 6179.61, @CantidadDescremada = 5542.11, @CantidadCrema = 1653.06, @CantidadPolvo = 1716.75, @CantidadPolvoDescremada = 2481.92, @PrecioUnitario = 4481.61, @FechaMovimiento = '2024-12-13', @FechaVencimiento = '2025-02-09', @IdEstadoOC = 1, @IdEstadoOF1 = 2, @IdEstadoOF2 = 1, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 32, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 14, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 4, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 16, @IdFormula3 = 13, @CantidadCruda = 19763.48, @CantidadEntera = 5815.4, @CantidadDescremada = 7720.92, @CantidadCrema = 2140.38, @CantidadPolvo = 1841.6, @CantidadPolvoDescremada = 1061.85, @PrecioUnitario = 4247.89, @FechaMovimiento = '2022-05-04', @FechaVencimiento = '2022-07-01', @IdEstadoOC = 1, @IdEstadoOF1 = 4, @IdEstadoOF2 = 3, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 31, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 16, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 11, @CantidadCruda = 17217.5, @CantidadEntera = 5806.09, @CantidadDescremada = 4880.47, @CantidadCrema = 1632.7, @CantidadPolvo = 2026.46, @CantidadPolvoDescremada = 1167.89, @PrecioUnitario = 2653.88, @FechaMovimiento = '2024-04-06', @FechaVencimiento = '2024-05-15', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 4, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 32, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 16, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 13, @CantidadCruda = 25710.71, @CantidadEntera = 8038.21, @CantidadDescremada = 8953.88, @CantidadCrema = 2022.71, @CantidadPolvo = 2810.12, @CantidadPolvoDescremada = 2300.83, @PrecioUnitario = 350.24, @FechaMovimiento = '2023-09-14', @FechaVencimiento = '2023-11-28', @IdEstadoOC = 2, @IdEstadoOF1 = 1, @IdEstadoOF2 = 3, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 8, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 4, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 13, @CantidadCruda = 26101.51, @CantidadEntera = 9069.08, @CantidadDescremada = 8861.4, @CantidadCrema = 1224.81, @CantidadPolvo = 2096.13, @CantidadPolvoDescremada = 3644.65, @PrecioUnitario = 4855.18, @FechaMovimiento = '2020-03-27', @FechaVencimiento = '2020-05-16', @IdEstadoOC = 1, @IdEstadoOF1 = 2, @IdEstadoOF2 = 4, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 38, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 16, @CodProdPolvoDescremada = 9, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 12, @IdFormula3 = 13, @CantidadCruda = 22549.93, @CantidadEntera = 5992.43, @CantidadDescremada = 4606.75, @CantidadCrema = 2529.23, @CantidadPolvo = 4940.09, @CantidadPolvoDescremada = 3621.74, @PrecioUnitario = 2429.24, @FechaMovimiento = '2025-04-19', @FechaVencimiento = '2025-05-25', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 2, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 35, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 16, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 2, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 10, @IdFormula3 = 13, @CantidadCruda = 24076.89, @CantidadEntera = 8985.64, @CantidadDescremada = 5917.6, @CantidadCrema = 1839.68, @CantidadPolvo = 4046.76, @CantidadPolvoDescremada = 1871.97, @PrecioUnitario = 822.05, @FechaMovimiento = '2022-03-02', @FechaVencimiento = '2022-05-28', @IdEstadoOC = 2, @IdEstadoOF1 = 1, @IdEstadoOF2 = 2, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 31, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 12, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 16, @IdFormula3 = 9, @CantidadCruda = 21311.55, @CantidadEntera = 6591.83, @CantidadDescremada = 4582.02, @CantidadCrema = 2358.95, @CantidadPolvo = 1843.09, @CantidadPolvoDescremada = 3973.46, @PrecioUnitario = 1799.23, @FechaMovimiento = '2020-06-17', @FechaVencimiento = '2020-08-28', @IdEstadoOC = 2, @IdEstadoOF1 = 4, @IdEstadoOF2 = 3, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 35, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 10, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 3, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 15, @CantidadCruda = 17638.16, @CantidadEntera = 6660.75, @CantidadDescremada = 4424.93, @CantidadCrema = 2665.14, @CantidadPolvo = 2165.46, @CantidadPolvoDescremada = 1219.74, @PrecioUnitario = 1364.08, @FechaMovimiento = '2024-10-21', @FechaVencimiento = '2024-11-27', @IdEstadoOC = 1, @IdEstadoOF1 = 4, @IdEstadoOF2 = 4, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 33, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 14, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 1, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 12, @IdFormula3 = 9, @CantidadCruda = 24332.49, @CantidadEntera = 8159.34, @CantidadDescremada = 5490.49, @CantidadCrema = 1416.31, @CantidadPolvo = 3844.29, @CantidadPolvoDescremada = 3771.57, @PrecioUnitario = 4068.83, @FechaMovimiento = '2020-05-01', @FechaVencimiento = '2020-07-03', @IdEstadoOC = 1, @IdEstadoOF1 = 1, @IdEstadoOF2 = 1, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 33, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 16, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 2, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 13, @CantidadCruda = 20123.26, @CantidadEntera = 6985.32, @CantidadDescremada = 5503.23, @CantidadCrema = 1520.9, @CantidadPolvo = 4094.46, @CantidadPolvoDescremada = 1232.18, @PrecioUnitario = 2169.14, @FechaMovimiento = '2021-02-07', @FechaVencimiento = '2021-04-23', @IdEstadoOC = 2, @IdEstadoOF1 = 1, @IdEstadoOF2 = 1, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 10, @CodProdPolvoDescremada = 9, @IdDepositoRecibo = 3, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 11, @CantidadCruda = 19621.67, @CantidadEntera = 6824.66, @CantidadDescremada = 4594.92, @CantidadCrema = 1042.91, @CantidadPolvo = 1850.59, @CantidadPolvoDescremada = 3486.23, @PrecioUnitario = 995.58, @FechaMovimiento = '2022-05-04', @FechaVencimiento = '2022-07-01', @IdEstadoOC = 1, @IdEstadoOF1 = 4, @IdEstadoOF2 = 3, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 29, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 12, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 1, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 16, @IdFormula3 = 13, @CantidadCruda = 20322.21, @CantidadEntera = 7798.97, @CantidadDescremada = 4720.9, @CantidadCrema = 1837.67, @CantidadPolvo = 2957.88, @CantidadPolvoDescremada = 1433.86, @PrecioUnitario = 1232.25, @FechaMovimiento = '2024-10-04', @FechaVencimiento = '2024-12-03', @IdEstadoOC = 1, @IdEstadoOF1 = 1, @IdEstadoOF2 = 1, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 12, @IdFormula3 = 11, @CantidadCruda = 27019.46, @CantidadEntera = 7970.93, @CantidadDescremada = 8638.56, @CantidadCrema = 2739.69, @CantidadPolvo = 3314.87, @CantidadPolvoDescremada = 3558.01, @PrecioUnitario = 411.88, @FechaMovimiento = '2024-11-21', @FechaVencimiento = '2025-01-09', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 3, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 1, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 13, @CantidadCruda = 18519.94, @CantidadEntera = 5019.3, @CantidadDescremada = 7205.33, @CantidadCrema = 1074.09, @CantidadPolvo = 1315.97, @CantidadPolvoDescremada = 2762.45, @PrecioUnitario = 4856.13, @FechaMovimiento = '2023-06-03', @FechaVencimiento = '2023-08-07', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 2, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 37, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 16, @CodProdPolvoDescremada = 9, @IdDepositoRecibo = 1, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 9, @CantidadCruda = 20001.0, @CantidadEntera = 6438.87, @CantidadDescremada = 5285.57, @CantidadCrema = 1399.25, @CantidadPolvo = 3335.11, @CantidadPolvoDescremada = 1830.72, @PrecioUnitario = 3555.31, @FechaMovimiento = '2021-06-21', @FechaVencimiento = '2021-09-04', @IdEstadoOC = 1, @IdEstadoOF1 = 3, @IdEstadoOF2 = 3, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 40, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 8, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 2, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 11, @CantidadCruda = 25178.41, @CantidadEntera = 8221.32, @CantidadDescremada = 8529.42, @CantidadCrema = 1695.76, @CantidadPolvo = 4464.21, @CantidadPolvoDescremada = 1764.62, @PrecioUnitario = 837.07, @FechaMovimiento = '2021-09-29', @FechaVencimiento = '2021-12-01', @IdEstadoOC = 1, @IdEstadoOF1 = 3, @IdEstadoOF2 = 3, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 38, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 14, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 3, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 10, @IdFormula3 = 15, @CantidadCruda = 22291.6, @CantidadEntera = 7507.26, @CantidadDescremada = 5767.11, @CantidadCrema = 1223.83, @CantidadPolvo = 3006.56, @CantidadPolvoDescremada = 3398.6, @PrecioUnitario = 817.7, @FechaMovimiento = '2021-11-15', @FechaVencimiento = '2022-02-12', @IdEstadoOC = 1, @IdEstadoOF1 = 1, @IdEstadoOF2 = 3, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 33, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 14, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 13, @CantidadCruda = 21744.32, @CantidadEntera = 6523.72, @CantidadDescremada = 8187.65, @CantidadCrema = 2488.88, @CantidadPolvo = 1135.47, @CantidadPolvoDescremada = 1909.19, @PrecioUnitario = 3662.78, @FechaMovimiento = '2022-08-22', @FechaVencimiento = '2022-10-13', @IdEstadoOC = 1, @IdEstadoOF1 = 2, @IdEstadoOF2 = 2, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 33, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 8, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 3, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 13, @CantidadCruda = 22498.52, @CantidadEntera = 8816.28, @CantidadDescremada = 8969.46, @CantidadCrema = 1625.27, @CantidadPolvo = 1395.53, @CantidadPolvoDescremada = 1015.88, @PrecioUnitario = 2267.18, @FechaMovimiento = '2023-08-14', @FechaVencimiento = '2023-11-11', @IdEstadoOC = 1, @IdEstadoOF1 = 1, @IdEstadoOF2 = 4, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 37, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 9, @IdDepositoRecibo = 3, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 11, @CantidadCruda = 21020.54, @CantidadEntera = 7338.36, @CantidadDescremada = 4788.01, @CantidadCrema = 2533.77, @CantidadPolvo = 3870.49, @CantidadPolvoDescremada = 1444.09, @PrecioUnitario = 1930.14, @FechaMovimiento = '2025-03-04', @FechaVencimiento = '2025-05-16', @IdEstadoOC = 1, @IdEstadoOF1 = 4, @IdEstadoOF2 = 4, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 30, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 8, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 11, @CantidadCruda = 23668.4, @CantidadEntera = 6241.65, @CantidadDescremada = 6336.01, @CantidadCrema = 1130.85, @CantidadPolvo = 4915.3, @CantidadPolvoDescremada = 3665.78, @PrecioUnitario = 4717.13, @FechaMovimiento = '2023-12-20', @FechaVencimiento = '2024-03-06', @IdEstadoOC = 1, @IdEstadoOF1 = 3, @IdEstadoOF2 = 2, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 32, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 8, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 14, @IdFormula3 = 15, @CantidadCruda = 21378.41, @CantidadEntera = 7333.45, @CantidadDescremada = 5765.27, @CantidadCrema = 1256.2, @CantidadPolvo = 3672.37, @CantidadPolvoDescremada = 1811.72, @PrecioUnitario = 2517.98, @FechaMovimiento = '2024-10-11', @FechaVencimiento = '2024-12-30', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 3, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 40, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 16, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 11, @CantidadCruda = 24055.01, @CantidadEntera = 9824.87, @CantidadDescremada = 6876.61, @CantidadCrema = 1945.1, @CantidadPolvo = 2474.79, @CantidadPolvoDescremada = 1003.64, @PrecioUnitario = 2417.04, @FechaMovimiento = '2024-09-26', @FechaVencimiento = '2024-12-14', @IdEstadoOC = 2, @IdEstadoOF1 = 4, @IdEstadoOF2 = 3, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 29, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 14, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 13, @CantidadCruda = 26884.63, @CantidadEntera = 9570.39, @CantidadDescremada = 7350.77, @CantidadCrema = 2902.76, @CantidadPolvo = 4336.65, @CantidadPolvoDescremada = 1869.33, @PrecioUnitario = 1507.57, @FechaMovimiento = '2022-07-13', @FechaVencimiento = '2022-09-16', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 4, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 39, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 14, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 14, @IdFormula3 = 9, @CantidadCruda = 25349.17, @CantidadEntera = 8713.37, @CantidadDescremada = 6579.95, @CantidadCrema = 2021.57, @CantidadPolvo = 4769.21, @CantidadPolvoDescremada = 2151.81, @PrecioUnitario = 2488.16, @FechaMovimiento = '2024-09-04', @FechaVencimiento = '2024-12-01', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 2, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 29, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 9, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 8, @IdFormula3 = 15, @CantidadCruda = 26386.83, @CantidadEntera = 6825.65, @CantidadDescremada = 8648.83, @CantidadCrema = 2697.05, @CantidadPolvo = 3084.2, @CantidadPolvoDescremada = 3969.8, @PrecioUnitario = 4510.18, @FechaMovimiento = '2022-05-01', @FechaVencimiento = '2022-06-24', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 4, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 1, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 12, @IdFormula3 = 11, @CantidadCruda = 23721.58, @CantidadEntera = 9763.54, @CantidadDescremada = 7698.02, @CantidadCrema = 1516.17, @CantidadPolvo = 3130.07, @CantidadPolvoDescremada = 1094.07, @PrecioUnitario = 663.33, @FechaMovimiento = '2021-05-12', @FechaVencimiento = '2021-07-06', @IdEstadoOC = 1, @IdEstadoOF1 = 1, @IdEstadoOF2 = 4, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 33, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 8, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 4, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 14, @IdFormula3 = 13, @CantidadCruda = 22718.08, @CantidadEntera = 8239.38, @CantidadDescremada = 5427.43, @CantidadCrema = 1496.73, @CantidadPolvo = 3548.73, @CantidadPolvoDescremada = 2872.22, @PrecioUnitario = 1794.28, @FechaMovimiento = '2024-03-12', @FechaVencimiento = '2024-05-03', @IdEstadoOC = 1, @IdEstadoOF1 = 3, @IdEstadoOF2 = 1, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 34, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 14, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 15, @CantidadCruda = 25189.82, @CantidadEntera = 7814.68, @CantidadDescremada = 6680.33, @CantidadCrema = 2702.04, @CantidadPolvo = 3956.95, @CantidadPolvoDescremada = 2689.47, @PrecioUnitario = 507.76, @FechaMovimiento = '2023-12-23', @FechaVencimiento = '2024-01-23', @IdEstadoOC = 1, @IdEstadoOF1 = 4, @IdEstadoOF2 = 3, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 31, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 16, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 11, @CantidadCruda = 26302.46, @CantidadEntera = 9653.36, @CantidadDescremada = 8806.25, @CantidadCrema = 1458.03, @CantidadPolvo = 2248.76, @CantidadPolvoDescremada = 3142.53, @PrecioUnitario = 4332.38, @FechaMovimiento = '2021-06-29', @FechaVencimiento = '2021-09-22', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 1, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 40, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 3, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 15, @CantidadCruda = 26572.38, @CantidadEntera = 8381.86, @CantidadDescremada = 6809.17, @CantidadCrema = 2985.45, @CantidadPolvo = 3844.81, @CantidadPolvoDescremada = 2939.35, @PrecioUnitario = 3619.73, @FechaMovimiento = '2022-11-03', @FechaVencimiento = '2022-12-29', @IdEstadoOC = 2, @IdEstadoOF1 = 1, @IdEstadoOF2 = 3, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 36, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 4, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 10, @IdFormula3 = 9, @CantidadCruda = 22967.77, @CantidadEntera = 6108.33, @CantidadDescremada = 7635.27, @CantidadCrema = 1128.3, @CantidadPolvo = 2501.44, @CantidadPolvoDescremada = 3997.94, @PrecioUnitario = 308.18, @FechaMovimiento = '2022-10-23', @FechaVencimiento = '2023-01-12', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 1, @IdEstadoOF3 = 2;
exec usp_simular_proceso_leche_completo @IdProveedor = 31, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 1, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 15, @CantidadCruda = 25118.81, @CantidadEntera = 9605.2, @CantidadDescremada = 5423.76, @CantidadCrema = 2700.75, @CantidadPolvo = 4553.45, @CantidadPolvoDescremada = 1065.41, @PrecioUnitario = 4245.61, @FechaMovimiento = '2022-06-20', @FechaVencimiento = '2022-08-09', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 1, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 34, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 8, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 10, @IdFormula3 = 9, @CantidadCruda = 21401.51, @CantidadEntera = 9460.03, @CantidadDescremada = 5383.92, @CantidadCrema = 2009.08, @CantidadPolvo = 2649.46, @CantidadPolvoDescremada = 1315.58, @PrecioUnitario = 1314.09, @FechaMovimiento = '2021-07-18', @FechaVencimiento = '2021-08-30', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 1, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 38, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 10, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 10, @IdFormula3 = 11, @CantidadCruda = 25366.03, @CantidadEntera = 8744.45, @CantidadDescremada = 7710.85, @CantidadCrema = 2120.27, @CantidadPolvo = 2306.72, @CantidadPolvoDescremada = 2737.39, @PrecioUnitario = 4815.57, @FechaMovimiento = '2022-08-09', @FechaVencimiento = '2022-10-13', @IdEstadoOC = 2, @IdEstadoOF1 = 4, @IdEstadoOF2 = 1, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 30, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 14, @CodProdPolvoDescremada = 13, @IdDepositoRecibo = 2, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 16, @IdFormula3 = 11, @CantidadCruda = 21522.29, @CantidadEntera = 8726.78, @CantidadDescremada = 4120.4, @CantidadCrema = 2453.95, @CantidadPolvo = 2471.8, @CantidadPolvoDescremada = 2470.08, @PrecioUnitario = 513.14, @FechaMovimiento = '2021-07-11', @FechaVencimiento = '2021-09-23', @IdEstadoOC = 1, @IdEstadoOF1 = 3, @IdEstadoOF2 = 4, @IdEstadoOF3 = 3;
exec usp_simular_proceso_leche_completo @IdProveedor = 30, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 36, @CodProdPolvo = 16, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 2, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 14, @IdFormula3 = 15, @CantidadCruda = 25579.61, @CantidadEntera = 9754.18, @CantidadDescremada = 6620.73, @CantidadCrema = 2888.11, @CantidadPolvo = 2441.05, @CantidadPolvoDescremada = 2173.62, @PrecioUnitario = 1068.43, @FechaMovimiento = '2023-09-12', @FechaVencimiento = '2023-11-20', @IdEstadoOC = 2, @IdEstadoOF1 = 4, @IdEstadoOF2 = 3, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 33, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 4, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 10, @IdFormula3 = 11, @CantidadCruda = 19208.66, @CantidadEntera = 7125.56, @CantidadDescremada = 5004.13, @CantidadCrema = 1673.05, @CantidadPolvo = 2800.85, @CantidadPolvoDescremada = 1636.49, @PrecioUnitario = 804.36, @FechaMovimiento = '2020-01-19', @FechaVencimiento = '2020-04-03', @IdEstadoOC = 2, @IdEstadoOF1 = 2, @IdEstadoOF2 = 3, @IdEstadoOF3 = 4;
exec usp_simular_proceso_leche_completo @IdProveedor = 30, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 8, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 4, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 14, @IdFormula3 = 15, @CantidadCruda = 24691.63, @CantidadEntera = 5856.83, @CantidadDescremada = 8819.7, @CantidadCrema = 2552.02, @CantidadPolvo = 1898.46, @CantidadPolvoDescremada = 3621.15, @PrecioUnitario = 2163.42, @FechaMovimiento = '2021-09-14', @FechaVencimiento = '2021-10-18', @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 3, @IdEstadoOF3 = 1;
exec usp_simular_proceso_leche_completo @IdProveedor = 31, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 12, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 3, @IdDepositoSecado = 6, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 14, @IdFormula3 = 13, @CantidadCruda = 21026.28, @CantidadEntera = 6638.85, @CantidadDescremada = 5853.1, @CantidadCrema = 1477.43, @CantidadPolvo = 1620.65, @CantidadPolvoDescremada = 3518.88, @PrecioUnitario = 2675.41, @FechaMovimiento = '2020-02-02', @FechaVencimiento = '2020-04-07', @IdEstadoOC = 2, @IdEstadoOF1 = 1, @IdEstadoOF2 = 3, @IdEstadoOF3 = 4;

----------------------------- FIN SCRIPT PYTHON


-- LO QUE SIGUE ESTA CARGADO ASI NOMAS POR CUESTIONES DE TIEMPO y POR NO SER SIGNIFICATIVO
SET IDENTITY_INSERT Usuario ON;INSERT INTO Usuario(IdUsuario,Clave,Nombre,Apellido,Email,FechaAlta) VALUES(100100,'clave123','Juan','Perez','juan.perez@lacteos.com',GETDATE()),(100200,'clave123','Maria','Lopez','maria.lopez@lacteos.com',GETDATE()),(100300,'clave123','Carlos','Gomez','carlos.gomez@lacteos.com',GETDATE()),(100400,'clave123','Ana','Martinez','ana.martinez@lacteos.com',GETDATE()),(100500,'clave123','Luis','Rodriguez','luis.rodriguez@lacteos.com',GETDATE()),(100600,'clave123','Sofia','Fernandez','sofia.fernandez@lacteos.com',GETDATE());SET IDENTITY_INSERT Usuario OFF;SET IDENTITY_INSERT Sector ON;INSERT INTO Sector(IdSector,Nombre) VALUES(200100,'Producción'),(200200,'Almacenamiento'),(200300,'Logística'),(200400,'Calidad'),(200500,'Ventas');SET IDENTITY_INSERT Sector OFF;SET IDENTITY_INSERT Deposito ON;INSERT INTO Deposito(IdDeposito,Nombre,Descripcion,IdSector) VALUES(300100,'Depósito Leche Cruda','Almacenamiento de leche cruda',200100),(300200,'Depósito Leche Pasteurizada','Almacenamiento leche pasteurizada',200200),(300300,'Depósito Dulce de Leche','Almacenamiento dulce de leche',200200),(300400,'Depósito Logístico','Depósito para expediciones',200300),(300500,'Depósito Calidad','Zona de control de calidad',200400);SET IDENTITY_INSERT Deposito OFF;SET IDENTITY_INSERT Producto ON;INSERT INTO Producto(CodProducto,Descripcion) VALUES(400100,'Leche Cruda'),(400200,'Leche Pasteurizada'),(400300,'Leche en Polvo'),(400400,'Dulce de Leche Frasco 1kg'),(400500,'Yogurt Natural 500ml'),(400600,'Queso Cremoso 200g'),(400700,'Manteca 250g');SET IDENTITY_INSERT Producto OFF;SET IDENTITY_INSERT OrdenEntrega ON;INSERT INTO OrdenEntrega(NroEntrega,SectorSolicita,SectorProvee,DepositoSolicita,DepositoProvee,UsuarioAlta,UsuarioRecepcion,IdEstadoOE,FechaAlta,FechaRecepcion,EsAnulado) VALUES(500100,200200,200100,300200,300100,100100,100200,1,GETDATE(),NULL,0),(500200,200300,200200,300400,300200,100300,NULL,2,GETDATE(),NULL,0),(500300,200500,200400,300400,300500,100400,100500,1,GETDATE(),NULL,0);SET IDENTITY_INSERT OrdenEntrega OFF;SET IDENTITY_INSERT MovimientoStock ON;INSERT INTO MovimientoStock(IdMovimiento,CodProducto,IdDeposito,IdUM,FechaVencimiento,FechaMovimiento,TipoMovimiento,CantidadModificada) VALUES(700100,400100,300100,1,DATEADD(day,5,GETDATE()),GETDATE(),'Ingreso',1000.00),(700200,400200,300200,1,DATEADD(day,10,GETDATE()),GETDATE(),'Ingreso',800.00),(700300,400400,300300,2,DATEADD(day,30,GETDATE()),GETDATE(),'Ingreso',300.00),(700400,400500,300200,2,DATEADD(day,15,GETDATE()),GETDATE(),'Ingreso',400.00),(700500,400200,300200,1,DATEADD(day,10,GETDATE()),GETDATE(),'Egreso',200.00),(700600,400600,300500,2,DATEADD(day,20,GETDATE()),GETDATE(),'Ingreso',150.00),(700700,400700,300500,2,DATEADD(day,25,GETDATE()),GETDATE(),'Ingreso',120.00),(700800,400300,300100,1,DATEADD(day,40,GETDATE()),GETDATE(),'Ingreso',500.00);SET IDENTITY_INSERT MovimientoStock OFF;INSERT INTO MovimientoEntrega(IdMovimiento,NroEntrega) VALUES(700100,500100),(700200,500100),(700500,500200),(700600,500300),(700700,500300),(700800,500100);SET IDENTITY_INSERT OrdenReposicion ON;INSERT INTO OrdenReposicion(NroReposicion,IdEstadoOR,EsAnulado) VALUES(600100,1,0),(600200,2,0),(600300,1,0);SET IDENTITY_INSERT OrdenReposicion OFF;INSERT INTO OrdenReposicionDetalle(NroReposicion,CodProducto,IdUM,Cantidad) VALUES(600100,400100,1,500.00),(600100,400300,1,200.00),(600200,400400,2,150.00),(600300,400600,2,100.00),(600300,400700,2,80.00);SET IDENTITY_INSERT TipoPallet ON;INSERT INTO TipoPallet(IdTipoPallet,IdUM,Nombre,Capacidad) VALUES(800100,2,'Pallet Frascos',100),(800200,1,'Pallet Sacos',50),(800300,1,'Pallet Cajas',75),(800400,2,'Pallet Queso',40);SET IDENTITY_INSERT TipoPallet OFF;SET IDENTITY_INSERT Pallet ON;INSERT INTO Pallet(IdPallet,IdTipoPallet,CantidadDisponible) VALUES(900100,800100,20),(900200,800200,15),(900300,800300,10),(900400,800400,25);SET IDENTITY_INSERT Pallet OFF;INSERT INTO MovimientoPallet(IdMovimiento,IdPallet) VALUES(700100,900200),(700200,900300),(700300,900100),(700600,900400),(700700,900400),(700800,900200);

