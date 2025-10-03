-- Attach the productos database
ATTACH DATABASE 'semana_3/database/productos.duckdb' AS productos_db;

-- Attach the clientes database
ATTACH DATABASE 'semana_3/database/clientes.duckdb' AS clientes_db;

-- Attach the ventas database
ATTACH DATABASE 'semana_3/database/ventas.duckdb' AS ventas_db;

WITH limites AS (
  SELECT
    date_trunc('quarter', MAX(fecha)) AS q_inicio,
    date_trunc('quarter', MAX(fecha)) + INTERVAL 3 MONTH - INTERVAL 1 DAY AS q_fin
  FROM ventas_db.ventas
),
ventas_filtradas AS (
  SELECT
    v.fecha,
    c.region,
    p.categoria,
    v.cantidad,
    v.precio
  FROM ventas_db.ventas v
  JOIN clientes_db.clientes  c ON v.cliente_id  = c.id
  JOIN productos_db.productos p ON v.producto_id = p.id
  -- solo traigo ultimo trimestre
  JOIN limites  l ON v.fecha BETWEEN l.q_inicio AND l.q_fin
)
SELECT
    region,
    categoria,
    SUM(cantidad * precio) AS ingresos
FROM ventas_filtradas
GROUP BY region, categoria
ORDER BY ingresos DESC;