create or alter procedure usp_simular_proceso_leche_completo
    @IdProveedor int, -- 29 a 40
    @CodProdLecheCruda int, -- 94
    @CodProdEntera int, -- 35 o 36
    @CodProdDescremada int, -- 35 o 36
    @CodProdCrema int, --35 o 36
    @CodProdPolvo int, -- 8, 10, 12, 14 o 16 
    @CodProdPolvoDescremada int, -- 9, 11, 13 o 15  
    @IdDepositoRecibo int, -- 1 a 4
    @IdDepositoSecado int, -- 6 a 8
    @IdLinea1 int, -- 1 
    @IdLinea2 int, -- 2 
    @IdLinea3 int, -- 3
    @IdFormula1 int, -- 35 o 36
    @IdFormula2 int, -- 8, 10, 12, 14, 16 
    @IdFormula3 int, -- 9, 11, 13 o 15  
    @CantidadCruda decimal(15,2), -- debe ser mayor a la suma de las otras cantidades, de 20000 a 50000
    @CantidadEntera decimal(15,2),
    @CantidadDescremada decimal(15,2),
    @CantidadCrema decimal(15,2),
    @CantidadPolvo decimal(15,2),
    @CantidadPolvoDescremada decimal(15,2), 
    @PrecioUnitario decimal(18,2), -- de 100 a 5000
    @FechaMovimiento datetime, -- tiene que ser desde el 2020 hasta la actualidad
    @FechaVencimiento datetime, -- 1 a 3 meses despues de FechaMovimiento
    @IdEstadoOC int, --'Solicitada', 'Recibida'
    @IdEstadoOF1 int, -- 'Planificado', 'En Proceso', 'Cerrado', 'Calidad'
    @IdEstadoOF2 int, -- 'Planificado', 'En Proceso', 'Cerrado', 'Calidad'
    @IdEstadoOF3 int -- 'Planificado', 'En Proceso', 'Cerrado', 'Calidad'
as
begin
    set nocount on;

    declare @IdUM int = (select IdUM from UnidadMedida where Nombre = 'LT');

    ----------------------
    -- 1. ORDEN DE COMPRA
    ----------------------

    declare @IdUsuarioOC int = (
        select top 1 IdUsuario from #JefeRecibo order by newid()
    );

    insert into OrdenCompra (IdProveedor, IdUsuario, IdEstadoOC)
    values (@IdProveedor, @IdUsuarioOC, @IdEstadoOC);

    declare @NroCompra int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdLecheCruda, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadCruda);

    declare @IdMovimientoCompra int = scope_identity();

    insert into MovimientoCompra (IdMovimiento, NroCompra, PrecioUnitario)
    values (@IdMovimientoCompra, @NroCompra, @PrecioUnitario);

    -------------------------------------------------------------
    -- 2. ORDEN DE FABRICACIÓN - CRUDA → ENTERA/DESCREMADA/CREMA
    -------------------------------------------------------------

    declare @IdUsuarioOF1 int = (
        select top 1 IdUsuario from #SupervisorRecibo order by newid()
    );

    insert into OrdenFabricacion (IdFormula, IdLinea, IdEstadoOF, IdUsuario)
    values (@IdFormula1, @IdLinea1, @IdEstadoOF1, @IdUsuarioOF1);

    declare @NroFabricacion1 int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdLecheCruda, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Egreso', -@CantidadCruda);

    declare @IdMovNeg1 int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovNeg1, @NroFabricacion1, 'Venta', 'Requiere');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdEntera, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadEntera);

    declare @IdMovEnt int = scope_identity();
    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovEnt, @NroFabricacion1, 'Venta', 'Transferencia Directa');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdDescremada, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadDescremada);

    declare @IdMovDesc int = scope_identity();
    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovDesc, @NroFabricacion1, 'Venta', 'Transferencia Directa');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdCrema, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadCrema);

    declare @IdMovCrema int = scope_identity();
    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovCrema, @NroFabricacion1, 'Venta', 'Transferencia Directa');

    -------------------------------------------------------------
    -- 3. ORDEN DE FABRICACIÓN - ENTERA → POLVO ENTERA
    -------------------------------------------------------------

    declare @IdUsuarioOF2 int = (
        select top 1 IdUsuario from #SupervisorRecibo order by newid()
    );

    insert into OrdenFabricacion (IdFormula, IdLinea, IdEstadoOF, IdUsuario)
    values (@IdFormula2, @IdLinea2, @IdEstadoOF2, @IdUsuarioOF2);

    declare @NroFabricacion2 int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdEntera, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Egreso', -@CantidadEntera);

    declare @IdMovNeg2 int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovNeg2, @NroFabricacion2, 'Venta', 'Requiere');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdPolvo, @IdDepositoSecado, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadPolvo);

    declare @IdMovPolvo int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovPolvo, @NroFabricacion2, 'Venta', 'Transferencia Directa');

    ---------------------------------------------------------------------
    -- 4. ORDEN DE FABRICACIÓN - DESCREMADA → POLVO DESCREMADA
    ---------------------------------------------------------------------

    declare @IdUsuarioOF3 int = (
        select top 1 IdUsuario from #SupervisorRecibo order by newid()
    );

    insert into OrdenFabricacion (IdFormula, IdLinea, IdEstadoOF, IdUsuario)
    values (@IdFormula3, @IdLinea3, @IdEstadoOF3, @IdUsuarioOF3);

    declare @NroFabricacion3 int = scope_identity();

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdDescremada, @IdDepositoRecibo, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Egreso', -@CantidadDescremada);

    declare @IdMovNeg3 int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovNeg3, @NroFabricacion3, 'Venta', 'Requiere');

    insert into MovimientoStock (CodProducto, IdDeposito, IdUM, FechaVencimiento, FechaMovimiento, TipoMovimiento, CantidadModificada)
    values (@CodProdPolvoDescremada, @IdDepositoSecado, @IdUM, @FechaVencimiento, @FechaMovimiento, 'Ingreso', @CantidadPolvoDescremada);

    declare @IdMovPolvoDesc int = scope_identity();

    insert into MovimientoFabricacion (IdMovimiento, NroFabricacion, Destino, Calidad)
    values (@IdMovPolvoDesc, @NroFabricacion3, 'Venta', 'Transferencia Directa');
end;
go
