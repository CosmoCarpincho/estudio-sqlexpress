-- procedure

create procedure nombre
    @atributo int
as
begin
    set nococunt on;
    -- codigo
end
go


-- while
declare @i int;
set @i = 0;

while (@i < 10)
begin
    if @i % 2 = 0
        begin
            print cast(@i as nvarchar) + ' Es par'
        end
        else
        begin
            print cast(@i as varchar) + ' Es impar'
        end
    set @i = @i + 1
end
go

-- funcion escalar
create function ufn_miFuncion
(
    @Numero int
)
returns int -- int es une escalar
as
begin
    return @Numero + 2;
end
go

-- funcion de tabla
create function ufn_miFuncionTabla
(
    @Parametro tipo
)
returns table
as
return
(
    select columna2, columna2
    from tabla
    where columaX = @Parametro
);
go

-- case
select
    case
        when condicion1 then resultado1
        when condicion2 then resultado2
        else ResultadoPorDefecto
    end as NombreColumna
    from tabla;
go


-- charindex


declare @cadena nvarchar(max);

set @cadena = 'Hola,que,tal'
print charindex(',', @cadena) -- devuelve posicion de la coma

declare @aux nvarchar;
set @aux = right(@cadena, 5)


print @aux
print @cadena

-- Procesar una lista

declare @Pos int;
while len(@cadena) > 0
begin
    set @Pos = charindex(',', @cadena);




end
