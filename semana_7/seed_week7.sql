DROP TABLE IF EXISTS ventas;

CREATE TABLE ventas (
  id INTEGER,
  factura_id TEXT,
  cliente_id INTEGER,
  fecha DATE,
  region TEXT,
  producto TEXT,
  cantidad INTEGER,
  monto DOUBLE
);

INSERT INTO ventas VALUES
-- OK
(1,'F-1001',10, DATE '2025-07-01','Norte','A',2,120.00),
(2,'F-1002',11, DATE '2025-07-02','Sur','B',1,80.00),
-- ERROR: monto negativo
(3,'F-1003',12, DATE '2025-07-03','Norte','C',1,-200.00),
-- ERROR: fecha futura
(4,'F-1004',13, CURRENT_DATE + INTERVAL 10 DAY,'Oeste','A',3,300.00),
-- ERROR: cliente nulo
(5,'F-1005',NULL, DATE '2025-07-05','Este','D',2,150.00),
-- ERROR: factura duplicada
(6,'F-1002',11, DATE '2025-07-02','Sur','B',1,80.00);
