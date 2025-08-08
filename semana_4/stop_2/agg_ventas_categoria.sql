-- agg_ventas_categoria.sql
WITH ventas_limpias AS (
    SELECT
        *,
        precio * cantidad AS total
    FROM ventas
    WHERE fecha IS NOT NULL
),
ventas_por_categoria AS (
    SELECT
        categoria,
        SUM(total) AS ingresos_totales
    FROM ventas_limpias
    GROUP BY categoria
)
SELECT *
FROM ventas_por_categoria
ORDER BY ingresos_totales DESC;
