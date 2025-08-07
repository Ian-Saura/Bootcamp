SELECT p.nombre, SUM(v.cantidad * v.precio) AS total
FROM ventas v
JOIN productos p ON v.producto_id = p.id
GROUP BY p.nombre
HAVING SUM(v.cantidad * v.precio) >
    (SELECT AVG(sub.total)
     FROM (
         SELECT SUM(cantidad * precio) AS total
         FROM ventas
         GROUP BY producto_id
     ) sub);
