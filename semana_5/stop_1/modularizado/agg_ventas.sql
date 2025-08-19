WITH base AS (
    SELECT * FROM stg_ventas
)
SELECT 
    DATE_TRUNC('month', fecha_venta) AS mes,
    SUM(monto) AS total_ventas
FROM base
GROUP BY mes;

--Cada archivo tiene un propósito claro y puede ser testeado individualmente`