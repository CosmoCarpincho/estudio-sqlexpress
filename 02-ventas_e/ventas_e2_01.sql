create database ventas_e;
go

use ventas_e;
go

create login cosmo
with password = 'cosmo'
go

create user cosmo for login cosmo;
go

exec sp_addrolemember 'db_owner', 'cosmo';
go


--ej 2

pongo directo uniquedentifier para trabajar en la nube.
create table Usuario (
    Token uniqueidentifier primary key default NEWID(),
    AyN varchar(100),
    Usuario varchar(50) not null,
    Password varchar(25) not null
);

create table Empresa (
    IdEmpresa uniqueidentifier primary key default NEWID(),
    RazonSocial varchar(100) not null,
    CUIT varchar(13) not null,
    Dominio varchar(50)
);
go

create table UsuarioXEmpresa (
    Token uniqueidentifier,
    IdEmpresa uniqueidentifier,

    constraint PK_Token_IdEmpresa primary key (Token, IdEmpresa),

    constraint FK_UsuarioXEmpresa_Usuario
        foreign key (Token) references Usuario(Token)
        on delete CASCADE,
    constraint FK_UsuarioXEmpresa_Empresa
        foreign key (IdEmpresa) references Empresa(IdEmpresa)
        on delete CASCADE
);

-- e para correr en la nube usar GUID iniqueidentifier. Para agregarlo default usar DEFAULT NEWID() 

-- Ej 3

alter table Usuario drop column Usuario;
go

alter table Usuario add Email varchar(70);
go

alter table Usuario
    add Domicilio varchar(150),
        Telefono varchar(30);
go


--ej 4

alter table Empresa add Telefono nvarchar(50);
alter table Empresa add Domicilio nvarchar(200);

insert into Empresa (RazonSocial, Domicilio, Telefono, CUIT, Dominio)
values  ('ABOCAR', '536 nro. 67', '0221 455-8523', '20-24563524-1', 'Albocar'),
        ('AUTOCLIPS VAER SA', 'Ate. Brown 876', '011 4457-7778', '30-56225853-4', 'Vaersa'),
        ('GOICOECHEA', 'Pte. Perón 4521', '0224 4522-3652', '30-57788523-5', 'Goicoechea'),
        ('CGO', '46 Nro. 1587', '0221 412-5623', '27-24245652-2', 'Districgo'),
        ('BELPE', '122 Nro. 4201', '0221 423-2323', '30-45235689-7', 'Belpe'),
        ('DISTRIFERR', 'Moreau Nro. 524', '0229 45-5623', '20-58545565-1', 'Distriferr'),
        ('AZ MOTOR', '44 esq. 200 Nro. 4522', '0221 452-5262', '30-44215532-5', 'Azmotor');


select * from Empresa;

--ej 5

select * from Usuario;
insert into Usuario(AyN, Password, Email, Domicilio, Telefono)
values ('Juan Barnetche', 'Juan', 'juancarnetche@gmail.com', '145 entre 22 y 23', '221 884423');

insert into UsuarioXEmpresa(Quiero poner a Juan con Empresa Belpe)
go

-- LO MEJOR ES USAR STORE PROCEDURE
create procedure RegistrarUsuarioYAsignarEmpresa
    @AyN varchar(100),
    @Password varchar(25),
    @Email varchar(70),
    @Domicilio varchar(150),
    @Telefono varchar(30),
    @RazonSocialEmpresa varchar(100)
as
begin
    --set nocount on;
    -- para que no muestre "1 fila(s) afectadas(s). Mejora rendimiento"

    declare @Token UNIQUEIDENTIFIER = NEWID();
    declare @IdEmpresa UNIQUEIDENTIFIER;

    select @IdEmpresa = IdEmpresa
    from Empresa
    where RazonSocial = @RazonSocialEmpresa;

    if @IdEmpresa IS NULL
    begin
        RAISERROR('La empresa con razón social proporcionada no existe.', 16, 1)
        -- 16 nivel de error, generado por el usuario
        -- 1 estado del error se deja en general en 1
        RETURN -- Finaliza el SP
    end

    insert into Usuario(Token, AyN, Password, Email, Domicilio, Telefono)
    values (@Token, @AyN, @Password, @Email, @Domicilio, @Telefono)

    insert into UsuarioXEmpresa(Token, IdEmpresa)
    values(@Token, @IdEmpresa)
end


select * from usuario; 
select * from empresa;

-- values ('Juan Barnetche', 'Juan', 'juancarnetche@gmail.com', '145 entre 22 y 23', '221 884423');
exec RegistrarUsuarioYAsignarEmpresa 'Juan Barnetche','juan123', 'juan12@gmail.com','123 y 55','221 4453342','BELPE' ;
exec RegistrarUsuarioYAsignarEmpresa 'Miguel Valcaneras','12migue','miguel@gmail.com','23 y 60','221 3334425','BELPE' ;
exec RegistrarUsuarioYAsignarEmpresa 'Analia Zamora','La vida es bella','anazamora@gmail.com','11 y 57','221 3321413','BELPE' ;
exec RegistrarUsuarioYAsignarEmpresa 'Maximiliano Moreno','MaxiPassword','maximilianomoreno@hotmail.com','23 y 41','221 5442343','CGO' ;
exec RegistrarUsuarioYAsignarEmpresa 'Tamara Castro','t#am?castro!123','tamcastro10@gmail.com','10 y 53','221 6543342','CGO' ;
exec RegistrarUsuarioYAsignarEmpresa 'Miguel Suarez','miguePass','migue-suarez-22@hotmail.com','12 y 32','221 8843323','GOICOECHEA' ;
exec RegistrarUsuarioYAsignarEmpresa 'Lionel Galo','lionelmessi10','lionelgalo3@gmail.com','1 y 60','221 8843349','GOICOECHEA' ;
exec RegistrarUsuarioYAsignarEmpresa 'Esperanza Mendez','1993esperanza','mendezesperanza@gmail.com','2 y 60','221 4432345','GOICOECHEA' ;
-- agregar manual a experanza mendez a AUTOCLIPS VAER SA
exec RegistrarUsuarioYAsignarEmpresa 'Maximiliano Gonzalez','123maxi123maxi','maxigonzalez1@gmail.com','3 y 43','221 2349532','ABOCAR' ;
exec RegistrarUsuarioYAsignarEmpresa 'Martín Perez','gidhh2bbgi0239','martinpincha@gmail.com','5 y 66','221 42345234','ABOCAR' ;


select count(*)
from UsuarioXEmpresa;

declare @Token UNIQUEIDENTIFIER;
declare @IdEmpresa UNIQUEIDENTIFIER;

select @Token = U.Token
from Usuario U
where U.AyN = 'Esperanza Mendez'

select @IdEmpresa = E.IdEmpresa
from Empresa E
where E.RazonSocial = 'AUTOCLIPS VAER SA'

exec sp_help 'UsuarioXEmpresa';

-- Forma manual de Experanza Mendez
select * from UsuarioXEmpresa;
insert into UsuarioXEmpresa(Token, IdEmpresa)
values (@Token, @IdEmpresa);


select count(*) from UsuarioXEmpresa;

-- ej6 a
select * from sys.tables;

select *
    from Usuario u inner join UsuarioXEmpresa uxe on u.Token = uxe.Token
    where u.AyN = 'Lionel Galo'

declare @t uniqueidentifier;
declare @idE uniqueidentifier;

select @idE = e.IdEmpresa from Empresa e where e.RazonSocial = 'CGO';
select  @t = u.Token from Usuario u where u.AyN = 'Lionel Galo';

print 'Id Empresa: ' + convert(varchar(50),@idE)
print 'Token Usuario: ' + convert(varchar(50), @t)
print 'FIN'

update UsuarioXEmpresa
set IdEmpresa = @idE
where Token = @t

select u.Token, u.AyN, e.RazonSocial, e.IdEmpresa 
    from Usuario u
    join UsuarioXEmpresa uxe on u.Token = uxe.Token
    join Empresa e on e.IdEmpresa = uxe.IdEmpresa
    where u.AyN = 'Lionel Galo';


--ej 6 b
select u.AyN, u.Token, e.IdEmpresa, e.RazonSocial
from Usuario u
join UsuarioXEmpresa uxe on u.Token = uxe.Token
join Empresa e on uxe.IdEmpresa = e.IdEmpresa
where u.AyN = 'Maximiliano Gonzalez'

-- baja de la empresa.
delete from Usuario
where AyN = 'Maximiliano Gonzalez'

select count(*) from UsuarioXEmpresa;

--ej 6 c
select * from Empresa;

update Empresa
set RazonSocial = 'ALBOCAR'
where RazonSocial = 'ABOCAR'

select * from Empresa e where e.RazonSocial = 'Albocar';

select * from
Usuario u join UsuarioXEmpresa uxe on u.Token = uxe.Token
join Empresa e on uxe.IdEmpresa = e.IdEmpresa
where e.RazonSocial = 'Az Motor'

select * from
UsuarioXEmpresa uxe join Empresa e on uxe.IdEmpresa = e.IdEmpresa
where e.Dominio = 'Azmotor'

select * from UsuarioXEmpresa uxe
where uxe.IdEmpresa = '58584046-b0a1-4b35-8594-8e0beda80aaa'

-- como no hay empleados en azmotor creo dos


exec RegistrarUsuarioYAsignarEmpresa 'Pepe Argento','pepe123','pepeargento@gmail.com','3 y 60','221 4552345','AZ MOTOR' ;
exec RegistrarUsuarioYAsignarEmpresa 'Alberto Iorio','albert123','albio@gmail.com','131 y 60','221 4442645','AZ MOTOR' ;

-- cambio de empresa

declare @nuevaEmpresa uniqueidentifier;
declare @viejaEmpresa uniqueidentifier;

select @nuevaEmpresa = e.IdEmpresa
from Empresa e
where e.RazonSocial = 'Albocar'

select @viejaEmpresa = e.IdEmpresa
from Empresa e
where e.RazonSocial = 'AZ MOTOR'

update UsuarioXEmpresa
set IdEmpresa = @nuevaEmpresa
where IdEmpresa = @viejaEmpresa

select * from
UsuarioXEmpresa uxe join Empresa e on uxe.IdEmpresa = e.IdEmpresa
where e.Dominio = 'Albocar'

--d

select * from Empresa;

select u.AyN, u.Password
from UsuarioXEmpresa uxe 
join Empresa e on uxe.IdEmpresa = e.IdEmpresa
join Usuario u on u.Token = uxe.Token
where e.RazonSocial = 'Goicoechea'

declare @contraseniaProvisoria varchar(25);
set @contraseniaProvisoria = 'nuevacontraseniaGOICO';

update Usuario
set Password = @contraseniaProvisoria
where Token IN (
    Select u.Token
    from Usuario u
    join UsuarioXEmpresa uxe on u.Token = uxe.Token
    join Empresa e on e.IdEmpresa = e.IdEmpresa
    where e.RazonSocial = 'Goicoechea'
)

exec sp_help 'Usuario';
