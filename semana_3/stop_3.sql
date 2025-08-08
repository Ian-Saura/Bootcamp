SELECT p.nombre,
       SUM(v.cantidad * v.precio) AS ingresos
FROM ventas v
INNER JOIN productos p ON v.producto_id = p.id
GROUP BY p.nombre
HAVING SUM(v.cantidad * v.precio) > (
    SELECT AVG(cant_por_prod) FROM (
        SELECT SUM(v2.cantidad * v2.precio) AS cant_por_prod
        FROM ventas v2
        GROUP BY v2.producto_id
    ) sub
);
