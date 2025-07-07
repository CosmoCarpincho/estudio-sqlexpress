use master;

create database vaquissima01;
go

use vaquissima01;
go

create table Usuario (
    IdUsuario int identity(1,1),
    Clave nvarchar(100) not null,
    Nombre nvarchar(50) not null,
    Apellido nvarchar(50),
    Email nvarchar(254) not null,
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
    constraint UQ_Rol_Nombre unique (Nombre)
);

create table UsuarioRol (
    IdUsuario int,
    IdRol int,

    constraint PK_UsuarioRol primary key (IdUsuario, IdRol),
    constraint FK_UsuarioRol_Usuario foreign key (IdUsuario) references Usuario(IdUsuario)
        on delete cascade,
    constraint FK_UsuarioRol_Rol foreign key (IdRol) references Rol(IdRol)
        on delete cascade
);

create table Sector (
    IdSector int identity(1,1),
    Nombre nvarchar(100) not null,

    constraint PK_Sector primary key (IdSector),
    constraint UQ_Sector_Nombre unique (Nombre)
);

create table Permiso (
    IdPermiso int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),

    constraint PK_Permiso primary key (IdPermiso),
    constraint UQ_Permiso_Nombre unique (Nombre)
);

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

    constraint UQ_PermisoOrdenSector_Unicidad unique (TipoOrden, IdSector, Accion)
);

create table RolPermiso (
    IdRol int,
    IdPermiso int,

    constraint PK_RolPermsio primary key (IdRol, IdPermiso),
    constraint FK_RolPermiso_IdRol foreign key (IdRol) references Rol(IdRol) on delete cascade,
    constraint FK_RolPermiso_IdPermiso foreign key (IdPermiso) references Permiso(IdPermiso) on delete cascade
);

create table Producto (
    CodProducto int identity(1,1),
    Descripcion nvarchar(255) not null,

    constraint PK_Producto primary key (CodProducto)
);


create table Formula (
    IdFormula int identity(1,1),
    Nombre nvarchar(100) not null,
    Descripcion nvarchar(255),
    CodProducto int not null,

    constraint PK_Formula primary key (IdFormula),
    constraint UQ_Formula_Nombre unique (Nombre),
    constraint FK_Formula_CodProducto foreign key (CodProducto) references Producto(CodProducto)
);
