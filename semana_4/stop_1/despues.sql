--ejemplo con sql

--Parametrizable por fechas (sustituí :desde / :hasta según tu motor)
--En SQL, la modularidad se logra con CTEs. Misma idea: base → clean → final.

WITH base AS (
  SELECT
    LOWER(TRIM(categoria)) AS categoria_norm,
    CAST(precio AS NUMERIC) AS precio,
    CAST(cantidad AS NUMERIC) AS cantidad,
    fecha
  FROM ventas
),
clean AS (
  SELECT
    INITCAP(categoria_norm) AS categoria,
    precio, cantidad, fecha,
    (precio * cantidad) AS ingresos
  FROM base
  WHERE precio IS NOT NULL AND cantidad IS NOT NULL
    AND fecha BETWEEN :desde AND :hasta
)
SELECT categoria, SUM(ingresos) AS ingresos
FROM clean
GROUP BY categoria
ORDER BY ingresos DESC;
