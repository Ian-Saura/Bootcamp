📝 Apunte: Orquestación mínima con Bash y Python
1) pipeline.sh — orquestador Bash (línea por línea)
bash
Copy
Edit
#!/usr/bin/env bash
Usa Bash encontrado por env (portabilidad).

bash
Copy
Edit
# Orquestador: corre 3 pasos en orden, loguea y corta si falla
Propósito del script.

bash
Copy
Edit
set -euo pipefail
-e: corta si algún comando falla.

-u: error si se usa variable no definida.

-o pipefail: si un comando de un pipe falla, falla todo.

bash
Copy
Edit
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Ruta absoluta del directorio del script (evita problemas con rutas relativas).

bash
Copy
Edit
LOG_DIR="${BASE_DIR}/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/pipeline_$(date +%Y%m%d_%H%M%S).log"
Carpeta de logs y archivo con timestamp por corrida.

bash
Copy
Edit
log() { echo "[$(date +%F) $(date +%T)] $*" | tee -a "$LOG_FILE" ; }
Función de logging: imprime y anexa al log.

bash
Copy
Edit
log "INICIO pipeline"
Marca de inicio en log.

bash
Copy
Edit
INPUT="${BASE_DIR}/data/ventas.csv"
if [[ ! -f "$INPUT" ]]; then
  log "ERROR: falta ${INPUT}"
  exit 2
fi
Validación de precondición (input). exit 2: código de error explícito.

bash
Copy
Edit
log "Paso 1: STG..."
bash "${BASE_DIR}/step_stg.sh"  >>"$LOG_FILE" 2>&1
log "STG OK"
Ejecuta STG. Redirige stdout y stderr al log (>>… 2>&1). Si falla, por set -e corta.

bash
Copy
Edit
log "Paso 2: DIM..."
bash "${BASE_DIR}/step_dim.sh"  >>"$LOG_FILE" 2>&1
log "DIM OK"
Ejecuta DIM con mismo patrón (corte si falla).

bash
Copy
Edit
log "Paso 3: FCT..."
bash "${BASE_DIR}/step_fct.sh"  >>"$LOG_FILE" 2>&1
log "FCT OK"
Ejecuta FCT (último paso).

bash
Copy
Edit
log "FIN pipeline ✅"
Marca de fin exitoso.

Pasos (step_stg.sh, step_dim.sh, step_fct.sh)
bash
Copy
Edit
#!/usr/bin/env bash
set -euo pipefail
echo "[STG|DIM|FCT] Mensaje..."
# exit 1  # usar para simular fallo en DIM y forzar corte
Cada paso hace una sola cosa y devuelve 0 si OK. exit 1 simula fallo.

2) run_pipeline.py — orquestador Python (línea por línea)
python
Copy
Edit
import subprocess, sys, time, pathlib, datetime
Ejecutar procesos, salir con códigos, timestamps y paths robustos.

python
Copy
Edit
BASE = pathlib.Path(__file__).resolve().parent
LOG_DIR = BASE / "logs"
LOG_DIR.mkdir(exist_ok=True)
LOG = LOG_DIR / f"pipeline_{datetime.datetime.now():%Y%m%d_%H%M%S}.log"
Directorio base, carpeta de logs y archivo con timestamp.

python
Copy
Edit
def run_step(cmd, name):
    print(f"[{time.strftime('%H:%M:%S')}] {name}")
    with LOG.open("a", encoding="utf-8") as f:
        f.write(f"[{time.strftime('%H:%M:%S')}] START {name}\n")
        p = subprocess.run(
            cmd, cwd=BASE,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
        )
        f.write(p.stdout + "\n")
        if p.returncode != 0:
            f.write(f"[{time.strftime('%H:%M:%S')}] FAIL {name} ({p.returncode})\n")
            print(f"❌ {name} falló. Corto.")
            sys.exit(p.returncode)
        f.write(f"[{time.strftime('%H:%M:%S')}] OK {name}\n")
    print(f"✅ {name} OK")
Ejecuta el paso, captura stdout+stderr juntos, escribe al log, corta si returncode != 0.

python
Copy
Edit
if __name__ == "__main__":
    data = BASE / "data" / "ventas.csv"
    if not data.exists():
        print(f"ERROR: falta {data}"); sys.exit(2)
Precondición: input presente o se aborta con código 2.

python
Copy
Edit
    run_step(["bash","step_stg.sh"], "STG")
    run_step(["bash","step_dim.sh"], "DIM")
    run_step(["bash","step_fct.sh"], "FCT")
    print("🏁 Pipeline completo")
Secuencia declarada: STG → DIM → FCT. Si DIM falla, FCT no corre.

3) stdout vs stderr (mini-cheat sheet)
stdout: salida “normal” del programa (mensajes informativos, resultados).

stderr: salida de errores o advertencias.

Redirecciones útiles:

Solo stdout: > out.log

Solo stderr: 2> err.log

Unificar ambos: > todo.log 2>&1

4) Cron (recordatorio)
ruby
Copy
Edit
0 3 * * * /usr/bin/env python3 /home/user/proyecto/run_pipeline.py >> /home/user/proyecto/logs/pipeline.cron.log 2>&1
Diario 03:00. Rutas absolutas. >> (append). 2>&1 (stderr→stdout).

Gestionar: crontab -e, crontab -l, crontab -r.

5) Buenas prácticas rápidas
Probar manual antes de cron.

Rutas absolutas y permisos +x.

Logs con timestamp.

Pasos pequeños y con exit codes claros.

Simular fallos (p. ej., exit 1 en DIM) para validar corte + logging.