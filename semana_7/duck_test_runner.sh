#!/usr/bin/env bash
set -euo pipefail
DB="${1:-week7.duckdb}"
LOG="${2:-tests_$(date +%Y%m%d_%H%M%S).log}"

echo "[INFO] Ejecutando tests sobre $DB" | tee -a "$LOG"

# Mostrar detalle por test
duckdb -csv -header "$DB" < tests_week7.sql | tee -a "$LOG"

# Obtener total_errores (único número)
TOTAL=$(duckdb -csv -header "$DB" < tests_total.sql | tail -n +2)

echo "[INFO] total_errores=$TOTAL" | tee -a "$LOG"

if [[ "${TOTAL:-0}" -gt 0 ]]; then
  echo "[ERROR] Tests fallidos (total_errores=$TOTAL)" | tee -a "$LOG"
  exit 1
fi

echo "[OK] Todos los tests pasaron" | tee -a "$LOG"
