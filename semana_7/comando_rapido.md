# Ver una tabla en DuckDB
duckdb week7.duckdb "SELECT * FROM ventas LIMIT 10;"

# Ver el KPI rápido
duckdb week7.duckdb < query_bad_kpi.sql

# Re-sembrar desde cero
duckdb week7.duckdb < seed_week7.sql