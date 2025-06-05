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

    -- JefePolvos
    select u.IdUsuario
    into #JefePolvos
    from Usuario u
    inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
    inner join Rol r on ur.IdRol = r.IdRol
    where r.Nombre = 'JefePolvos';

    -- SupervisorPolvos
    select u.IdUsuario
    into #SupervisorPolvos
    from Usuario u
    inner join UsuarioRol ur on u.IdUsuario = ur.IdUsuario
    inner join Rol r on ur.IdRol = r.IdRol
    where r.Nombre = 'SupervisorPolvos';

    declare @IdUM int = (select IdUM from UnidadMedida where Nombre = 'LT');

    ----------------------
    -- 1. ORDEN DE COMPRA
    ----------------------

    declare @IdUsuarioOC int = (
        select top 1 IdUsuario from Usuario where IdUsuario between 2 and 8 order by newid()
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
        select top 1 IdUsuario from (
            select IdUsuario from #JefeRecibo
            union all
            select IdUsuario from #SupervisorRecibo
        ) as Recibo order by newid()
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
        select top 1 IdUsuario from (
            select IdUsuario from #JefePolvos
            union all
            select IdUsuario from #SupervisorPolvos
        ) as Polvos order by newid()
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
        select top 1 IdUsuario from (
            select IdUsuario from #JefePolvos
            union all
            select IdUsuario from #SupervisorPolvos
        ) as Polvos order by newid()
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


exec usp_simular_proceso_leche_completo @IdProveedor = 30, @CodProdLecheCruda = 94, @CodProdEntera = 35, @CodProdDescremada = 35, @CodProdCrema = 35, @CodProdPolvo = 10, @CodProdPolvoDescremada = 15, @IdDepositoRecibo = 1, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 14, @IdFormula3 = 15, @CantidadCruda = 22787.11, @CantidadEntera = 5253.8, @CantidadDescremada = 7711.44, @CantidadCrema = 1430.71, @CantidadPolvo = 3227.47, @CantidadPolvoDescremada = 3648.09, @PrecioUnitario = 3220.48, @IdEstadoOC = 2, @IdEstadoOF1 = 3, @IdEstadoOF2 = 4, @IdEstadoOF3 = 1, @FechaMovimiento = '2021-02-22', @FechaVencimiento = '2021-05-04';
exec usp_simular_proceso_leche_completo @IdProveedor = 35, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 36, @CodProdCrema = 35, @CodProdPolvo = 10, @CodProdPolvoDescremada = 11, @IdDepositoRecibo = 1, @IdDepositoSecado = 7, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 35, @IdFormula2 = 8, @IdFormula3 = 9, @CantidadCruda = 24815.47, @CantidadEntera = 6517.71, @CantidadDescremada = 8522.62, @CantidadCrema = 1368.51, @CantidadPolvo = 4424.27, @CantidadPolvoDescremada = 2517.55, @PrecioUnitario = 1612.55, @IdEstadoOC = 2, @IdEstadoOF1 = 4, @IdEstadoOF2 = 4, @IdEstadoOF3 = 2, @FechaMovimiento = '2020-01-25', @FechaVencimiento = '2020-04-05';
exec usp_simular_proceso_leche_completo @IdProveedor = 30, @CodProdLecheCruda = 94, @CodProdEntera = 36, @CodProdDescremada = 35, @CodProdCrema = 36, @CodProdPolvo = 16, @CodProdPolvoDescremada = 9, @IdDepositoRecibo = 3, @IdDepositoSecado = 8, @IdLinea1 = 1, @IdLinea2 = 2, @IdLinea3 = 3, @IdFormula1 = 36, @IdFormula2 = 12, @IdFormula3 = 9, @CantidadCruda = 19419.39, @CantidadEntera = 5342.67, @CantidadDescremada = 8415.16, @CantidadCrema = 1530.38, @CantidadPolvo = 1407.57, @CantidadPolvoDescremada = 1655.96, @PrecioUnitario = 4318.54, @IdEstadoOC = 1, @IdEstadoOF1 = 2, @IdEstadoOF2 = 3, @IdEstadoOF3 = 3, @FechaMovimiento = '2020-09-28', @FechaVencimiento = '2020-12-10';
--- .... usar script python