-- Primero comprar leche cruda
-- Movimientos en cantidades positivas. Unidad de medida LT

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

declare @IdUM int;
select @IdUM =  IdUM from UnidadMedida where Nombre = 'LT';


-- TABLAS
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
    constraint CK_MovimientoStock_TipoMovimiento check (TipoMovimiento in ('Ingreso', 'Egreso', 'Espera'))
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