#!/usr/bin/env python3
"""
Script para ejecutar create_ventas_duck.sql y generar 3 archivos separados:
- productos.duckdb
- clientes.duckdb  
- ventas.duckdb

Uso: python create_3_duckdb_files.py
"""
import duckdb
import os

# Obtener el directorio del script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Leer el archivo SQL completo
sql_file = os.path.join(script_dir, 'create_ventas_duck.sql')
with open(sql_file, 'r', encoding='utf-8') as f:
    sql_content = f.read()

# Crear conexión temporal en memoria para cargar todo
print("📁 Cargando datos desde create_ventas_duck.sql...")
temp_conn = duckdb.connect(':memory:')
temp_conn.execute(sql_content)

# ============================================================================
# 1. CREAR productos.duckdb
# ============================================================================
productos_db = os.path.join(script_dir, 'productos.duckdb')
if os.path.exists(productos_db):
    os.remove(productos_db)

print("\n📦 Creando productos.duckdb...")
conn_productos = duckdb.connect(productos_db)
conn_productos.execute("""
    CREATE TABLE productos (
        id INTEGER PRIMARY KEY,
        nombre VARCHAR NOT NULL,
        categoria VARCHAR NOT NULL,
        precio_base DECIMAL(10,2) NOT NULL
    );
""")

# Copiar datos de productos
productos_data = temp_conn.execute("SELECT * FROM productos").fetchall()
for row in productos_data:
    conn_productos.execute("INSERT INTO productos VALUES (?, ?, ?, ?)", row)

count_productos = conn_productos.execute("SELECT COUNT(*) FROM productos").fetchone()[0]
print(f"   ✅ productos.duckdb: {count_productos} registros")
conn_productos.close()

# ============================================================================
# 2. CREAR clientes.duckdb
# ============================================================================
clientes_db = os.path.join(script_dir, 'clientes.duckdb')
if os.path.exists(clientes_db):
    os.remove(clientes_db)

print("\n👥 Creando clientes.duckdb...")
conn_clientes = duckdb.connect(clientes_db)
conn_clientes.execute("""
    CREATE TABLE clientes (
        id INTEGER PRIMARY KEY,
        nombre VARCHAR NOT NULL,
        region VARCHAR NOT NULL,
        email VARCHAR
    );
""")

# Copiar datos de clientes
clientes_data = temp_conn.execute("SELECT * FROM clientes").fetchall()
for row in clientes_data:
    conn_clientes.execute("INSERT INTO clientes VALUES (?, ?, ?, ?)", row)

count_clientes = conn_clientes.execute("SELECT COUNT(*) FROM clientes").fetchone()[0]
print(f"   ✅ clientes.duckdb: {count_clientes} registros")
conn_clientes.close()

# ============================================================================
# 3. CREAR ventas.duckdb
# ============================================================================
ventas_db = os.path.join(script_dir, 'ventas.duckdb')
if os.path.exists(ventas_db):
    os.remove(ventas_db)

print("\n💰 Creando ventas.duckdb...")
conn_ventas = duckdb.connect(ventas_db)
conn_ventas.execute("""
    CREATE TABLE ventas (
        id INTEGER PRIMARY KEY,
        fecha DATE NOT NULL,
        producto_id INTEGER,
        cliente_id INTEGER,
        cantidad INTEGER NOT NULL,
        precio DECIMAL(10,2) NOT NULL
    );
""")

# Copiar datos de ventas
ventas_data = temp_conn.execute("SELECT * FROM ventas").fetchall()
for row in ventas_data:
    conn_ventas.execute("INSERT INTO ventas VALUES (?, ?, ?, ?, ?, ?)", row)

count_ventas = conn_ventas.execute("SELECT COUNT(*) FROM ventas").fetchone()[0]
print(f"   ✅ ventas.duckdb: {count_ventas} registros")
conn_ventas.close()

# Cerrar conexión temporal
temp_conn.close()

# ============================================================================
# RESUMEN
# ============================================================================
print("\n" + "="*60)
print("✅ 3 archivos DuckDB generados exitosamente!")
print("="*60)
print(f"📦 productos.duckdb  ({os.path.getsize(productos_db):,} bytes)")
print(f"👥 clientes.duckdb   ({os.path.getsize(clientes_db):,} bytes)")
print(f"💰 ventas.duckdb     ({os.path.getsize(ventas_db):,} bytes)")
print("\n💡 Ahora puedes ejecutar queries en cada archivo:")
print("   duckdb productos.duckdb < tu_query.sql")
print("   duckdb clientes.duckdb < tu_query.sql")
print("   duckdb ventas.duckdb < stop_1.sql")





