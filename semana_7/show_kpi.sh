#!/usr/bin/env bash
set -euo pipefail
DB="${1:-week7.duckdb}"

# seed + mostrar KPI
duckdb "$DB" < seed_week7.sql
echo "[INFO] KPI total_ventas (puede estar roto):"
duckdb "$DB" < query_bad_kpi.sql
