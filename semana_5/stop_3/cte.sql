-- stg_ventas.sql
WITH ventas_limpias AS (
    SELECT
        v.cliente_id,
        DATE(v.fecha) AS fecha_venta,
        v.monto
    FROM raw.ventas v
    WHERE v.fecha IS NOT NULL
),
dim_clientes AS (
    SELECT DISTINCT
        c.id AS cliente_id,
        TRIM(c.nombre) AS nombre_cliente
    FROM raw.clientes c
),
fct_ventas AS (
    SELECT
        vl.fecha_venta,
        dc.nombre_cliente,
        SUM(vl.monto) AS total_ventas
    FROM ventas_limpias vl
    JOIN dim_clientes dc ON vl.cliente_id = dc.cliente_id
    GROUP BY vl.fecha_venta, dc.nombre_cliente
)
SELECT * FROM fct_ventas;
