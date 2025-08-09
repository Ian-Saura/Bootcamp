#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${BASE_DIR}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/pipeline_$(date +%Y%m%d_%H%M%S).log"

# Evita dos corridas simultáneas
exec 200>"${BASE_DIR}/.pipeline.lock"
flock -n 200 || { echo "[$(date +%F) $(date +%T)] Ya hay una corrida activa" | tee -a "$LOG_FILE"; exit 1; }

log(){ echo "[$(date +%F) $(date +%T)] $*" | tee -a "$LOG_FILE"; }
on_error(){ log "❌ Error en línea $1. Abortando."; }
trap 'on_error $LINENO' ERR

log "INICIO pipeline"

INPUT="${BASE_DIR}/data/ventas.csv"
if [[ ! -f "$INPUT" ]]; then
  log "ERROR: falta ${INPUT}"
  exit 2
fi

log "Paso 1: STG..."; bash "${BASE_DIR}/step_stg.sh"  >>"$LOG_FILE" 2>&1; log "STG OK"
log "Paso 2: DIM..."; bash "${BASE_DIR}/step_dim.sh"  >>"$LOG_FILE" 2>&1; log "DIM OK"
log "Paso 3: FCT..."; bash "${BASE_DIR}/step_fct.sh"  >>"$LOG_FILE" 2>&1; log "FCT OK"

log "FIN pipeline ✅"


#0 3 * * * /usr/bin/env bash /home/user/proyecto/pipeline.sh >> /home/user/proyecto/logs/pipeline.cron.log 2>&1
