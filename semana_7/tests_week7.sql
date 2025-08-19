-- Devuelve una tabla test|errores (una fila por test)
WITH tests AS (
  SELECT 'not_null_cliente' AS test, COUNT(*) AS errores
  FROM ventas WHERE cliente_id IS NULL
  UNION ALL
  SELECT 'monto_no_negativo', COUNT(*) FROM ventas WHERE monto < 0
  UNION ALL
  SELECT 'fecha_no_futura', COUNT(*) FROM ventas WHERE fecha > CURRENT_DATE
  UNION ALL
  SELECT 'factura_unica', COUNT(*) FROM (
    SELECT factura_id
    FROM ventas
    GROUP BY 1
    HAVING COUNT(*) > 1
  )
)
SELECT * FROM tests;
