SELECT UPPER(p.nombre) AS producto
FROM ventas v
JOIN productos p ON v.producto_id = p.id
WHERE p.categoria = 'Bebidas';