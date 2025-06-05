exec usp_cantidad_usuarios_por_sector;

exec usp_usuarios_pertenecen_a_sector 'Dulceria';

exec usp_stock_por_producto @CodProducto = 94;
exec usp_stock_por_producto 52;
exec usp_stock_por_producto 14;
exec usp_stock_por_producto 51;

exec usp_stock_por_deposito @IdDeposito = 1;
exec usp_stock_por_deposito @IdDeposito = 12;
exec usp_stock_por_deposito @IdDeposito = 6;
exec usp_stock_por_deposito @IdDeposito = 22;

exec usp_obtener_produccion_mensual_por_producto;
exec usp_obtener_produccion_mensual_por_producto 36;


exec usp_obtener_produccion_anual_por_producto;
exec usp_obtener_produccion_anual_por_producto 36;

exec usp_gasto_mensual;

exec usp_cantidad_de_usuarios_por_permiso;

exec usp_cantidad_de_usuarios_por_rol;

declare @IdUsuario int = (select IdUsuario from UsuarioRol ur join Rol r on ur.IdRol = r.IdRol where r.Nombre = 'Admin');
exec usp_permisos_de_usuario @IdUsuario;
exec usp_permisos_de_usuario 33;

exec usp_cantidad_usuarios_por_sector_orden;

exec usp_sector_orden_del_usuario 1;
exec usp_sector_orden_del_usuario 33;

exec usp_sector_ordenes_usuarios_info;

exec usp_stock_por_producto_y_deposito @CodProducto = 94, @IdDeposito = 2;
exec usp_stock_por_producto_y_deposito @CodProducto = 73, @IdDeposito = 12;

exec usp_obtener_produccion_mensual_todos_productos_por_fecha;
exec usp_obtener_produccion_mensual_todos_productos_por_fecha '2023-04-01', '2024-06-01';


exec usp_gasto_anual;

exec usp_gasto_periodo @FechaInicio = '2023-01-01',  @FechaFin = '2025-06-05';

exec usp_gasto_por_producto;
exec usp_gasto_por_producto 64;

exec usp_gasto_anual_por_producto;

exec usp_gasto_por_proveedor;
exec usp_gasto_por_proveedor @IdProveedor = 37;
