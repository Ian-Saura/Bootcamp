-- Attach the productos database
ATTACH DATABASE 'semana_3/database/productos.duckdb' AS productos_db;

-- Attach the clientes database
ATTACH DATABASE 'semana_3/database/clientes.duckdb' AS clientes_db;

-- Attach the ventas database
ATTACH DATABASE 'semana_3/database/ventas.duckdb' AS ventas_db;



WITH ingresos_categoria AS (
    SELECT p.categoria,
           SUM(v.cantidad * v.precio) AS ingresos
    FROM ventas_db.ventas v
    INNER JOIN productos_db.productos p ON v.producto_id = p.id
    GROUP BY p.categoria
),
total_global AS (
    SELECT SUM(ingresos) AS total FROM ingresos_categoria
)
SELECT ic.categoria,
       ic.ingresos,
       ROUND((ic.ingresos / tg.total) * 100, 2) AS porcentaje
FROM ingresos_categoria ic
CROSS JOIN total_global tg
ORDER BY porcentaje DESC;
