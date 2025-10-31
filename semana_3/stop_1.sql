ATTACH DATABASE 'semana_3/database/ventas.duckdb' AS ventas_db;



SELECT *
FROM ventas_db.ventas
WHERE fecha BETWEEN '2024-01-01' AND '2024-03-31'
  AND cantidad >= 5
  ORDER BY fecha;


#duckdb < semana_3/stop_1.sql

Argentina
Argentina
