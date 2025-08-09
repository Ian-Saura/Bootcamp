SELECT *
FROM ventas
JOIN clientes ON ventas.cliente_id = clientes.id;
