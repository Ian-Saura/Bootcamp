-- Attach the productos database
ATTACH DATABASE 'semana_3/database/productos.duckdb' AS productos_db;

-- Attach the clientes database
ATTACH DATABASE 'semana_3/database/clientes.duckdb' AS clientes_db;

-- Attach the ventas database
ATTACH DATABASE 'semana_3/database/ventas.duckdb' AS ventas_db;

SELECT c.region,
       SUM(v.cantidad * v.precio) AS ingresos_totales
FROM ventas_db.ventas v
INNER JOIN productos_db.productos p ON v.producto_id = p.id
INNER JOIN clientes_db.clientes AS c ON v.cliente_id = c.id
GROUP BY c.region
ORDER BY ingresos_totales DESC;
