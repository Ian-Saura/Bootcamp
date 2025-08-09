import subprocess, sys, time, pathlib, datetime, logging

BASE = pathlib.Path(__file__).resolve().parent
LOG_DIR = BASE / "logs"; LOG_DIR.mkdir(exist_ok=True)
LOG = LOG_DIR / f"pipeline_{datetime.datetime.now():%Y%m%d_%H%M%S}.log"

logging.basicConfig(
    filename=str(LOG),
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

def run_step(cmd, name):
    logging.info("START %s", name)
    p = subprocess.run(cmd, cwd=BASE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    logging.info("OUTPUT %s\n%s", name, p.stdout)
    if p.returncode != 0:
        logging.error("FAIL %s (code=%s)", name, p.returncode)
        print(f"❌ {name} falló. Corto.")
        sys.exit(p.returncode)
    logging.info("OK %s", name)
    print(f"✅ {name} OK")

if __name__ == "__main__":
    data = BASE / "data" / "ventas.csv"
    if not data.exists():
        logging.error("Falta %s", data); print(f"ERROR: falta {data}"); sys.exit(2)
    run_step(["bash","step_stg.sh"], "STG")
    run_step(["bash","step_dim.sh"], "DIM")
    run_step(["bash","step_fct.sh"], "FCT")
    print("🏁 Pipeline completo")


