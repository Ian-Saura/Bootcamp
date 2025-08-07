SELECT p.nombre, SUM(v.cantidad * v.precio) AS ingresos
FROM ventas v
JOIN productos p ON v.producto_id = p.id
GROUP BY p.nombre
ORDER BY ingresos DESC;
