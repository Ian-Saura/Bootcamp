-- trf_ventas.sql
WITH ventas_limpias AS (
    SELECT
        *,
        precio * cantidad AS total
    FROM ventas
    WHERE fecha IS NOT NULL
)
SELECT * FROM ventas_limpias;
