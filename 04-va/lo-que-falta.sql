-- Que tablas me falta llenar algo
-- MovimientoEntrega
-- MovimientoPallet
-- OrdenEntrega
-- OrdenReposicion
-- OrdenReposicionDetalle
-- Pallet
-- TipoPallet

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