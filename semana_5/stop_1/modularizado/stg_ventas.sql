SELECT 
    cliente_id,
    TRIM(nombre) AS nombre_limpio,
    DATE(fecha) AS fecha_venta,
    monto
FROM ventas_raw
WHERE fecha IS NOT NULL;

--Cada archivo tiene un propósito claro y puede ser testeado individualmente