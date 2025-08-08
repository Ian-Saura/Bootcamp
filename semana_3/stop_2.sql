SELECT c.region,
       SUM(v.cantidad * v.precio) AS ingresos_totales
FROM ventas v
INNER JOIN productos p ON v.producto_id = p.id
INNER JOIN clientes c ON v.cliente_id = c.id
GROUP BY c.region
ORDER BY ingresos_totales DESC;
