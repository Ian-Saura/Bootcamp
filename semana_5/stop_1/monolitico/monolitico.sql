SELECT 
    cliente_id,
    TRIM(nombre) AS nombre_limpio,
    DATE(fecha) AS fecha_venta,
    monto
FROM ventas_raw
WHERE fecha IS NOT NULL
;
-- Luego agregación
WITH ventas_mensuales AS (
    SELECT 
        DATE_TRUNC('month', fecha_venta) AS mes,
        SUM(monto) AS total_ventas
    FROM ventas_raw
    GROUP BY mes
)
SELECT * FROM ventas_mensuales;


--Todo en un solo archivo: difícil de leer, difícil de testear.