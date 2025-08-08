#!/usr/bin/env python3
'''
Pipeline runner: carga CSV -> SQLite -> ejecuta SQLs -> exporta resultado
Usa:
  - ventas_stop2.csv
  - stg_ventas.sql
  - trf_ventas.sql
  - agg_ventas_categoria.sql
Guarda:
  - outputs_stop3/agg_result.csv
  - outputs_stop3/pipeline.log
'''

import sqlite3
import pandas as pd
from pathlib import Path
from datetime import datetime

BASE = Path(__file__).resolve().parent
DB = BASE / "stop3.db"
CSV = BASE / "ventas_stop2.csv"
SQL_STG = BASE / "stg_ventas.sql"
SQL_TRF = BASE / "trf_ventas.sql"
SQL_AGG = BASE / "agg_ventas_categoria.sql"
OUT_DIR = BASE / "outputs_stop3"
OUT_DIR.mkdir(exist_ok=True)
LOG = OUT_DIR / "pipeline.log"

def log(msg):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with LOG.open("a", encoding="utf-8") as f:
        f.write(f"[{ts}] {msg}\n")
    print(msg)

def run_sql(conn, sql_text):
    cur = conn.cursor()
    cur.execute("PRAGMA foreign_keys = ON;")
    try:
        cur.execute("SELECT 1;")
    except Exception:
        pass
    return pd.read_sql_query(sql_text, conn)

def main():
    # DB limpia
    if DB.exists():
        DB.unlink()
    conn = sqlite3.connect(DB)
    log("DB creada")

    # Cargar CSV -> tabla ventas
    df = pd.read_csv(CSV)
    df.to_sql("ventas", conn, index=False)
    log(f"Ventas cargadas: {len(df)} filas")

    # Ejecutar STG
    stg_sql = Path(SQL_STG).read_text(encoding="utf-8")
    stg_df = run_sql(conn, stg_sql)
    log(f"STG filas: {len(stg_df)}")

    # Ejecutar TRF
    trf_sql = Path(SQL_TRF).read_text(encoding="utf-8")
    trf_df = run_sql(conn, trf_sql)
    if not {"precio","cantidad","total"}.issubset(trf_df.columns):
        raise RuntimeError("Columnas esperadas faltantes en TRF")
    if (trf_df["total"] < 0).any():
        raise RuntimeError("Total negativo detectado")
    log(f"TRF filas: {len(trf_df)}")

    # Ejecutar AGG
    agg_sql = Path(SQL_AGG).read_text(encoding="utf-8")
    agg_df = run_sql(conn, agg_sql)
    out_csv = OUT_DIR / f"agg_result_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    agg_df.to_csv(out_csv, index=False)
    log(f"AGG OK → {out_csv.name}")

    conn.close()
    log("Pipeline finalizado OK")

if __name__ == "__main__":
    main()
