create table TiposAlimento(
	IdAlimento int identity(1,1),
	Nombre nvarchar(255),

	constraint PK_TiposAlimento primary key (IdAlimento),
	
	);
go

insert into TiposAlimento(Nombre)
values
('Maiz'),
('Arroz'),
('Carne')
go


create table Razas(
	IdRaza int identity(1,1),
	Descripcion nvarchar(255),

	constraint PK_Razas primary key (IdRaza)
);
go



create table Animales(
	IdAnimal int identity(1,1),
	Nombre nvarchar(255),
	IdRaza int,
	FechaNacimiento datetime,

	constraint PK_Animales primary key (IdAnimal),
	constraint FK_Animales_Raza foreign key (IdRaza) references Razas(IdRaza)
);
go

create table ConsumoDiario(
	IdConsumo int identity(1,1),
	IdAnimal int,
	IdAlimento int,
	Fecha datetime,
	Cantidad int

	constraint PK_ConsumoDiario primary key (IdConsumo),
	constraint FK_ConsumoDiario_Animal foreign key (IdAnimal) references Animales(IdAnimal),
	constraint FK_ConsumoDIario_Alimento foreign key (IdAlimento) references TiposAlimento(IdAlimento)
);
go

create table UbicacionDiaria(
	IdUbicacion int identity(1,1),
	IdAnimal int,
	Fecha datetime,
	Corral int,

	constraint PK_UbicacionDiaria primary key (IdUbicacion),
	constraint FK_UbicacionDiaria_Animales foreign key (IdAnimal) references Animales(IdAnimal)
);
go

INSERT INTO Razas(Descripcion)
VALUES
('Hereford'),
('Angus'),
('Brahman');

INSERT INTO Animales(Nombre, IdRaza, FechaNacimiento)
VALUES
('Toro 1', 1, '2020-03-15'),
('Vaca 2', 2, '2019-07-22'),
('Ternero 3', 3, '2023-01-05');


INSERT INTO ConsumoDiario(IdAnimal, IdAlimento, Fecha, Cantidad)
VALUES
(1, 1, '2025-07-01', 5),
(1, 2, '2025-07-01', 3),
(2, 1, '2025-07-02', 4),
(3, 3, '2025-07-02', 2);


INSERT INTO UbicacionDiaria(IdAnimal, Fecha, Corral)
VALUES
(1, '2025-07-01', 101),
(1, '2025-07-02', 102),
(2, '2025-07-01', 201),
(3, '2025-07-02', 301);
go
create or alter procedure usp_corrales_mas_alimentados
    @FechaInicio datetime,
    @FechaFin datetime
as
begin
    set nocount on;

    select 
        u.Corral,
        count(distinct c.IdAnimal) as TotalAnimalesAlimentados
    from ConsumoDiario c
    inner join UbicacionDiaria u
        on c.IdAnimal = u.IdAnimal and cast(c.Fecha as date) = cast(u.Fecha as date)
    where c.Fecha between @FechaInicio and @FechaFin
    group by u.Corral
    having count(distinct c.IdAnimal) = (
        select top 1 count(distinct c2.IdAnimal)
        from ConsumoDiario c2
        inner join UbicacionDiaria u2
            on c2.IdAnimal = u2.IdAnimal and cast(c2.Fecha as date) = cast(u2.Fecha as date)
        where c2.Fecha between @FechaInicio and @FechaFin
        group by u2.Corral
        order by count(distinct c2.IdAnimal) desc
    )
end
go

exec usp_corrales_mas_alimentados 
    @FechaInicio = '2023-01-01',
    @FechaFin = '2023-12-31';
go	

create procedure elimine_registros 
	@NombreAlimento nvarchar(255),
	@NombreAnimal nvarchar(255)
as
begin

	
	select *
	from ConsumoDiario cd
	join TiposAlimento ta on cd.IdAlimento = ta.IdAlimento
	join Animales a on cd.IdAnimal = a.IdAnimal
	where a.Nombre = @NombreAnimal and ta.Nombre = @NombreAlimento
	
	

end

GO


-- NO EXISTE tal cosa...->
select distinct ud.Corral
from UbicacionDiaria ud
where not exists (
	select *
	from UbicacionDiaria ud2
	join Animales a on ud2.IdAnimal = a.IdAnimal
	join Razas r on a.IdRaza = r.IdRaza
	where r.Descripcion = 'Hereford'
		and ud2.Corral = ud.Corral
);