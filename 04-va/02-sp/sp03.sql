create or alter procedure usp_stock_por_producto
    @CodProducto int
as
begin
    set nocount on;

    select 
        d.IdDeposito,
        d.Nombre as NombreDeposito,
        sum(ms.CantidadModificada) as StockActual,
        um.Nombre as UnidadMedida
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.CodProducto = @CodProducto
    group by d.IdDeposito, d.Nombre, um.IdUM, um.Nombre
    having sum(ms.CantidadModificada) <> 0
    order by d.Nombre;
end;
go

exec usp_stock_por_producto 94 --Leche cruda
exec usp_stock_por_producto 52 -- Separador carton
exec usp_stock_por_producto 14 --Leche en Polvo
exec usp_stock_por_producto 51 -- Bolsa papel kraft
go



create or alter procedure usp_stock_por_producto_y_deposito
    @CodProducto int,
    @IdDeposito int
as
begin
    set nocount on;

    select 
        d.IdDeposito,
        d.Nombre as NombreDeposito,
        p.CodProducto,
        p.Descripcion as NombreProducto,
        sum(ms.CantidadModificada) as StockActual,
        um.Nombre as UnidadMedida
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join Producto p on p.CodProducto = ms.CodProducto
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.CodProducto = @CodProducto
      and ms.IdDeposito = @IdDeposito
    group by d.IdDeposito, d.Nombre, p.CodProducto, p.Descripcion, um.Nombre
    having sum(ms.CantidadModificada) <> 0
    order by p.Descripcion;
end;
go

exec usp_stock_por_producto_y_deposito @CodProducto = 94, @IdDeposito = 3;
exec usp_stock_por_producto_y_deposito @CodProducto = 73, @IdDeposito = 12;
go


create or alter procedure usp_stock_por_deposito
    @IdDeposito int
as
begin
    set nocount on;

    select 
        d.IdDeposito,
        d.Nombre as NombreDeposito,
        p.CodProducto,
        p.Descripcion as NombreProducto,
        sum(ms.CantidadModificada) as StockActual,
        um.Nombre as UnidadMedida
    from MovimientoStock ms
    inner join Deposito d on d.IdDeposito = ms.IdDeposito
    inner join Producto p on p.CodProducto = ms.CodProducto
    inner join UnidadMedida um on um.IdUM = ms.IdUM
    where ms.IdDeposito = @IdDeposito
    group by d.IdDeposito, d.Nombre, p.CodProducto, p.Descripcion, um.Nombre
    having sum(ms.CantidadModificada) <> 0
    order by p.Descripcion;
end;
go

exec usp_stock_por_deposito @IdDeposito = 1;
exec usp_stock_por_deposito @IdDeposito = 12;
exec usp_stock_por_deposito @IdDeposito = 6;
exec usp_stock_por_deposito @IdDeposito = 22;
go

