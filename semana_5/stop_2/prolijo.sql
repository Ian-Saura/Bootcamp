-- stg_ventas.sql
-- Limpieza de ventas: normaliza fechas y nombres de columnas
SELECT
    v.cliente_id,
    DATE(v.fecha) AS fecha_venta,
    v.monto
FROM raw.ventas v
WHERE v.fecha IS NOT NULL;

-- dim_clientes.sql
-- Catálogo único de clientes con ID y nombre
SELECT DISTINCT
    c.id AS cliente_id,
    TRIM(c.nombre) AS nombre_cliente
FROM raw.clientes c;
