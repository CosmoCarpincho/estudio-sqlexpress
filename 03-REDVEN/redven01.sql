-- TP 9

-- ej1
-- select * from Cliente;


-- select * from sys.tables

-- select 'Cliente'as NombreTabla, count(*) as CantidadFilas from Cliente
-- union all
-- select 'Empresa', count(*) from Empresa

-- select t.name as NombreTabla, p.rows as CantidadFilas
-- from sys.tables t JOIN sys.partitions p ON t.object_id = p.object_id
-- where p.index_id IN (0, 1)
-- group by t.name, p.rows
-- order by CantidadFilas DESC;

--ej2 otra cosa

-- select *
-- from cliente c
-- order by c.IDTipoIva desc, c.RazonSocial ASC

--ej3


-- select cliente.IDTipoIva, CantidadClientes = count(cliente.IdTipoIva)
-- from cliente
-- group by cliente.IdTipoIva;

-- ej4 (diferente)
-- select all * 
-- from cliente c
-- where c.NombreUsuario = 'Maria'


--ej5
-- select cliente.NombreUsuario , Cantidad = COUNT(cliente.NombreUsuario)
-- from cliente
-- group by cliente.NombreUsuario

--ej6 fecha en venta <- itemventa -> articulo 
select articulo.Descripcion
from  articulo a
    left join itemventa i on a.idArticulo = i.idArticulo
    left join venta v on v.idVenta = i.idVenta
where v.Fecha = GETDATE()
group by articulo.Descripcion



