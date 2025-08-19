WITH tests AS (
  SELECT COUNT(*) AS errores FROM ventas WHERE cliente_id IS NULL
  UNION ALL
  SELECT COUNT(*) FROM ventas WHERE monto < 0
  UNION ALL
  SELECT COUNT(*) FROM ventas WHERE fecha > CURRENT_DATE
  UNION ALL
  SELECT COUNT(*) FROM (
    SELECT factura_id
    FROM ventas
    GROUP BY 1
    HAVING COUNT(*) > 1
  )
)
SELECT SUM(errores) AS total_errores FROM tests;

