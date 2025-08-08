-- Create productos table
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    categoria VARCHAR NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL
);

-- Create clientes table
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR NOT NULL,
    region VARCHAR NOT NULL,
    email VARCHAR
);

-- Create ventas table
CREATE TABLE ventas (
    id INTEGER PRIMARY KEY,
    fecha DATE NOT NULL,
    producto_id INTEGER,
    cliente_id INTEGER,
    cantidad INTEGER NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Insert sample productos with more varied categories
INSERT INTO productos (id, nombre, categoria, precio_base) VALUES
    (1, 'Coca Cola', 'Bebidas', 2.50),
    (2, 'Pepsi', 'Bebidas', 2.40),
    (3, 'Agua Mineral', 'Bebidas', 1.00),
    (4, 'Pan Integral', 'Panadería', 3.50),
    (5, 'Galletas', 'Snacks', 1.80),
    (6, 'Café', 'Bebidas', 5.00),
    (7, 'Leche', 'Lácteos', 2.20),
    (8, 'Cerveza', 'Bebidas', 3.00),
    (9, 'Chocolate', 'Dulces', 2.30),
    (10, 'Pizza Congelada', 'Congelados', 8.50);

-- Insert sample clientes with varied regions
INSERT INTO clientes (id, nombre, region, email) VALUES
    (1, 'Juan Pérez', 'Norte', 'juan@email.com'),
    (2, 'María García', 'Sur', 'maria@email.com'),
    (3, 'Carlos López', 'Centro', 'carlos@email.com'),
    (4, 'Ana Martínez', 'Norte', 'ana@email.com'),
    (5, 'Pedro Sánchez', 'Sur', 'pedro@email.com'),
    (6, 'Laura Torres', 'Centro', 'laura@email.com'),
    (7, 'Miguel Ruiz', 'Norte', 'miguel@email.com');

-- Insert sample ventas with varied dates and quantities
INSERT INTO ventas (id, fecha, producto_id, cliente_id, cantidad, precio) VALUES
    -- Q1 2024 sales (for stop_1.sql)
    (1, '2024-01-15', 1, 1, 6, 2.50),   -- Large Coca Cola order
    (2, '2024-02-20', 2, 2, 3, 2.40),   -- Small Pepsi order
    (3, '2024-03-10', 3, 3, 8, 1.00),   -- Large Agua Mineral order
    (4, '2024-02-05', 4, 4, 2, 3.50),   -- Small Pan order
    (5, '2024-01-25', 5, 5, 5, 1.80),   -- Medium Galletas order
    (6, '2024-03-20', 6, 1, 7, 5.00),   -- Large Café order
    (7, '2024-02-15', 7, 2, 4, 2.20),   -- Medium Leche order
    (8, '2024-01-05', 8, 3, 6, 3.00),   -- Large Cerveza order
    (9, '2024-03-01', 1, 4, 5, 2.50),   -- Medium Coca Cola order
    (10, '2024-02-10', 2, 5, 3, 2.40),  -- Small Pepsi order
    
    -- Previous year sales for comparison
    (11, '2023-12-15', 3, 6, 4, 1.00),
    (12, '2023-12-20', 4, 7, 5, 3.50),
    (13, '2023-11-25', 5, 1, 6, 1.80),
    (14, '2023-11-10', 6, 2, 3, 5.00),
    (15, '2023-10-05', 7, 3, 7, 2.20),
    
    -- Additional sales for better distribution
    (16, '2024-01-20', 9, 4, 4, 2.30),   -- Chocolate
    (17, '2024-02-25', 10, 5, 2, 8.50),  -- Pizza
    (18, '2024-03-15', 8, 6, 5, 3.00),   -- Cerveza
    (19, '2024-01-10', 1, 7, 6, 2.50),   -- Coca Cola
    (20, '2024-02-28', 6, 1, 3, 5.00);   -- Café