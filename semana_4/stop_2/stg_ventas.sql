-- stg_ventas.sql
SELECT
    fecha,
    cliente,
    producto,
    precio,
    cantidad,
    categoria
FROM ventas
WHERE fecha IS NOT NULL;
