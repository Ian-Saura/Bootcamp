DROP TABLE IF EXISTS fct_ventas_mensual;

CREATE TABLE fct_ventas_mensual AS
SELECT
  strftime(fecha, '%Y-%m') AS mes,
  region,
  SUM(monto) AS ingreso_total
FROM ventas
GROUP BY 1,2
ORDER BY 1,2;
