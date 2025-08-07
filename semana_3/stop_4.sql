WITH ventas_region AS (
    SELECT c.region, SUM(v.cantidad * v.precio) AS ingresos
    FROM ventas v
    JOIN clientes c ON v.cliente_id = c.id
    GROUP BY c.region
),
total_ingresos AS (
    SELECT SUM(ingresos) AS total FROM ventas_region
)
SELECT vr.region,
       ROUND((vr.ingresos / ti.total) * 100, 2) AS porcentaje
FROM ventas_region vr
CROSS JOIN total_ingresos ti;
