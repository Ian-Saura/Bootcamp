SELECT *
FROM ventas
WHERE fecha BETWEEN '2024-01-01' AND '2024-03-31'
  AND cantidad >= 5;


#duckdb semana_3/ventas.duckdb < semana_3/stop_1.sql