#!/usr/bin/env bash
set -euo pipefail
DB="${1:-week7.duckdb}"
PIPELOG="pipeline_$(date +%Y%m%d_%H%M%S).log"

echo "[INFO] Seed inicial" | tee -a "$PIPELOG"
duckdb "$DB" < seed_week7.sql       >>"$PIPELOG" 2>&1

echo "[INFO] KPI previo" | tee -a "$PIPELOG"
duckdb "$DB" < query_bad_kpi.sql    >>"$PIPELOG" 2>&1

echo "[INFO] Corriendo tests..." | tee -a "$PIPELOG"
bash ./duck_test_runner.sh "$DB" "tests_${DB}_$(date +%H%M%S).log" || {
  echo "[ERROR] Tests fallidos. Corto pipeline." | tee -a "$PIPELOG"
  exit 1
}

echo "[INFO] Tests OK. Construyendo FCT..." | tee -a "$PIPELOG"
duckdb "$DB" < fct_ventas.sql       >>"$PIPELOG" 2>&1

echo "[OK] Pipeline completado" | tee -a "$PIPELOG"
