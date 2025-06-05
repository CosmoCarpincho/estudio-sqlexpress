create table Producto (
    CodProducto int identity(1,1),
    Descripcion nvarchar(255) not null,
    constraint PK_Producto primary key (CodProducto)
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
create table Telefono (
    IdTelefono int identity(1,1),
    Numero nvarchar(30) not null,
    constraint PK_Telefono primary key (IdTelefono),
    constraint UQ_Telefono_Numero unique (Numero)
);
create table Proveedor (
    IdProveedor int identity(1,1),
    Nombre nvarchar(50) not null,
    Calle nvarchar(100),
    Nro nvarchar(20),
    Localidad nvarchar(100),
    constraint PK_Proveedor primary key (IdProveedor),
    constraint UQ_Proveedor_Nombre unique (Nombre)
);
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
    constraint PK_MovimientoCompra primary key (IdMovimiento, NroCompra),
    constraint FK_MovimientoCompra_MovimientoStock foreign key (IdMovimiento) references MovimientoStock(IdMovimiento),
    constraint FK_MovimientoCompra_OrdenCompra foreign key (NroCompra) references OrdenCompra(NroCompra),
    constraint CK_MovimientoCompra_PrecioUnitario check (PrecioUnitario >= 0)
);