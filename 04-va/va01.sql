-- use master;

-- create database va05;
-- go

use va05;
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

create table Permiso (
    IdPermiso int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar (255),

    constraint PK_Permiso primary key (IdPermiso),
    constraint UQ_Permiso_Nombre unique (Nombre)
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

create table Sector (
    IdSector int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),

    constraint PK_Sector primary key (IdSector),
    constraint UQ_Sector_Nombre unique (Nombre)
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

    constraint PK_Deposito primary key (IdDeposito),
    constraint UQ_Deposito_Nombre unique (Nombre)
);

create table MovimientoStock (
    IdMovimiento int identity(1,1),
    CodProducto int not null,
    IdDeposito int not null,
    IdUM int not null,

    FechaVencimiento datetime not null,
    FechaMovimiento datetime not null default getdate(),
    TipoMovimiento varchar(7) not null,
    CantidadModificada decimal(15,4) not null,
    --Lote nvarchar(255) not null, -- CodProducto-FechaVencimiento

    constraint PK_MovimientoStock primary key (IdMovimiento),
    constraint FK_MovimientoStock_Producto foreign key (CodProducto) references Producto(CodProducto),
    constraint FK_MovimientoStock_Deposito foreign key (IdDeposito) references Deposito(IdDeposito),
    constraint FK_MovimientoStock_UnidadMedida foreign key (IdUM) references UnidadMedida(IdUM),
    constraint CK_MovimientoStock_TipoMovimiento check (TipoMovimiento in ('Ingreso', 'Egreso'))
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
    Cantidad decimal(15,4),


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

-- TipoPallet
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
--Pallet 
create table Pallet (
    IdPallet int identity(1,1),
    IdTipoPallet int not null,
    CantidadDisponible int, -- Se calcula con movimientos Pallet

    constraint PK_Pallet primary key (IdPallet),
    constraint FK_Pallet_TipoPallet foreign key (IdTipoPallet) references TipoPallet(IdTipoPallet),
    constraint CK_Pallet_CantidadDisponible check (CantidadDisponible >= 0)
);
-- MovimientoPallet
create table MovimientoPallet (
    IdMovimiento int,
    IdPallet int,

    constraint PK_MovimientoPallet primary key (IdMovimiento, IdPallet),
    constraint FK_MovimientoPallet_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoPallet_Pallet foreign key (IdPallet) references Pallet(IdPallet)
);

----
-- Telefono
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

-- EstadoOC
create table EstadoOC (
    IdEstadoOC int identity(1,1),
    Nombre varchar(10) not null,

    constraint PK_EstadoOC primary key (IdEstadoOC),
    constraint UQ_EstadoOC_Nombre unique (Nombre),
    constraint CK_EstadoOC_Nombre check (Nombre in ('Solicitada', 'Recibida'))
);

-- OrdenCompra
-- Agregar Usuario 
create table OrdenCompra (
    NroCompra int identity(1,1),
    IdUsuario int not null,
    IdEstadoOC int not null,
    FechaCompra datetime not null,

    constraint PK_OrdenCompra primary key (NroCompra),
    constraint FK_OrdenCompra_Usuario foreign key (IdUsuario) references Usuario(IdUsuario),
    constraint FK_OrdenCompra_EstadoOC foreign key (IdEstadoOC) references EstadoOC(IdEstadoOC)
);

-- MovimientoCompra
create table MovimientoCompra (
    IdMovimiento int,
    NroCompra int,
    PrecioUnitario decimal(18,2) not null,
    Cantidad int not null, -- CAMBIOS: se agrego

    constraint PK_MovimientoCompra primary key (IdMovimiento, NroCompra),
    constraint FK_MovimientoCompra_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoCompra_OrdenCompra foreign key (NroCompra) references OrdenCompra(NroCompra),
    constraint CK_MovimientoCompra_Cantidad check (Cantidad > 0),
    constraint CK_MovimientoCompra_PrecioUnitario check (PrecioUnitario >= 0)
);
