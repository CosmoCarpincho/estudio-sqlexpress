-- QUe tablas necesitamos para stock

create table Sector (
    IdSector int identity(1,1),
    Nombre nvarchar(100) not null,
    constraint PK_Sector primary key (IdSector),
    constraint UQ_Sector_Nombre unique (Nombre)
);
create table Producto (
    CodProducto int identity(1,1),
    Descripcion nvarchar(255) not null,
    constraint PK_Producto primary key (CodProducto)
);
create table EstadoOF (
    IdEstadoOF int identity(1,1),
    Nombre varchar(11) not null,
    constraint PK_EstadoOF primary key (IdEstadoOF),
    constraint UQ_EstadoOF_Nombre unique (Nombre),
    constraint CK_EstadoOF_Nombre check (
        Nombre in ('Planificado', 'En Proceso', 'Cerrado', 'Calidad'))
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
    IdSector int not null,
    constraint PK_Deposito primary key (IdDeposito),
    constraint UQ_Deposito_Nombre unique (Nombre),
    constraint PK_Deposito_Sector foreign key (IdSector) references Sector(IdSector)
);
create table Linea (
    IdLinea int identity(1,1),
    IdSector int not null,
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),
    constraint PK_Linea primary key (IdLinea),
    constraint FK_Linea_Sector foreign key (IdSector) references Sector(IdSector),
    constraint UQ_Linea_Nombre unique (Nombre)
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
    constraint PK_MovimientoStock primary key (IdMovimiento),
    constraint FK_MovimientoStock_Producto foreign key (CodProducto) references Producto(CodProducto),
    constraint FK_MovimientoStock_Deposito foreign key (IdDeposito) references Deposito(IdDeposito),
    constraint FK_MovimientoStock_UnidadMedida foreign key (IdUM) references UnidadMedida(IdUM),
    constraint CK_MovimientoStock_TipoMovimiento check (TipoMovimiento in ('Ingreso', 'Egreso', 'Espera')) -- CAMBIOS: Se agrega espera
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