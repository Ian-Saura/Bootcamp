-- Attach the productos database
ATTACH DATABASE 'semana_3/database/productos.duckdb' AS productos_db;

-- Attach the clientes database
ATTACH DATABASE 'semana_3/database/clientes.duckdb' AS clientes_db;

-- Attach the ventas database
ATTACH DATABASE 'semana_3/database/ventas.duckdb' AS ventas_db;

SELECT p.nombre,
       SUM(v.cantidad * v.precio) AS ingresos
FROM ventas_db.ventas v
INNER JOIN productos_db.productos p ON v.producto_id = p.id
GROUP BY p.nombre
HAVING SUM(v.cantidad * v.precio) > (
    SELECT AVG(cant_por_prod) FROM (
        SELECT SUM(v2.cantidad * v2.precio) AS cant_por_prod
        FROM ventas_db.ventas v2
        GROUP BY v2.producto_id
    ) sub
);

