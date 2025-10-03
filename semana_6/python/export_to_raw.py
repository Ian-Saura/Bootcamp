import argparse, os, pathlib, sys, datetime
from typing import List

import pandas as pd
from sqlalchemy import create_engine, inspect, text


def list_tables(connection_string: str, include: List[str] | None, exclude: List[str] | None) -> List[str]:
    engine = create_engine(connection_string)
    with engine.connect() as conn:
        insp = inspect(conn)
        tables = []
        for schema in insp.get_schema_names():
            # Ignore internal schemas commonly used by some databases
            if schema in {"information_schema", "pg_catalog", "sqlite_master"}:
                continue
            for t in insp.get_table_names(schema=schema):
                fq = f"{schema}.{t}" if schema not in {None, '', 'public'} else t
                tables.append(fq)
        # If no schemas or empty, try default
        if not tables:
            tables = insp.get_table_names() or []
    if include:
        include_set = {t.lower() for t in include}
        tables = [t for t in tables if t.lower() in include_set]
    if exclude:
        exclude_set = {t.lower() for t in exclude}
        tables = [t for t in tables if t.lower() not in exclude_set]
    return tables


def dump_table_to_csv(connection_string: str, table_name: str, out_dir: pathlib.Path, chunk_size: int = 100_000) -> pathlib.Path:
    engine = create_engine(connection_string)
    out_dir.mkdir(parents=True, exist_ok=True)

    safe_name = table_name.replace("/", "_").replace(".", "_")
    out_file = out_dir / f"{safe_name}.csv"

    with engine.connect() as conn:
        # Support fully-qualified names; wrap with quotes where needed
        query = f"SELECT * FROM {table_name}"
        first = True
        for chunk in pd.read_sql_query(text(query), conn, chunksize=chunk_size):
            mode = "w" if first else "a"
            header = first
            chunk.to_csv(out_file, index=False, mode=mode, header=header)
            first = False
    return out_file


def main() -> int:
    parser = argparse.ArgumentParser(description="Exportar tablas desde una BBDD relacional a CSVs en carpeta raw")
    parser.add_argument("--db-url", dest="db_url", required=False, default=os.environ.get("DB_URL"), help="Cadena de conexión SQLAlchemy, ej: postgresql+psycopg2://user:pass@host:5432/db")
    parser.add_argument("--out", dest="out", default=str(pathlib.Path(__file__).resolve().parents[1] / "outputs" / "raw"), help="Carpeta destino para los CSVs")
    parser.add_argument("--include", nargs="*", help="Lista de tablas a incluir (nombre o schema.tabla)")
    parser.add_argument("--exclude", nargs="*", help="Lista de tablas a excluir")
    parser.add_argument("--table", dest="table", help="Exportar solo una tabla (alias de --include con un item)")
    parser.add_argument("--chunk-size", type=int, default=100_000, help="Tamaño de chunk para exportar en streaming")
    args = parser.parse_args()

    if not args.db_url:
        print("ERROR: falta --db-url o variable de entorno DB_URL", file=sys.stderr)
        return 2

    out_dir = pathlib.Path(args.out)

    include = args.include
    if args.table:
        include = [args.table]

    print(f"Conectando a {args.db_url}")
    tables = list_tables(args.db_url, include, args.exclude)
    if not tables:
        print("No se encontraron tablas para exportar")
        return 0

    print(f"Exportaré {len(tables)} tabla(s) a {out_dir}")
    started = datetime.datetime.now()
    successes: List[pathlib.Path] = []
    failures: List[str] = []
    for t in tables:
        try:
            out_file = dump_table_to_csv(args.db_url, t, out_dir, chunk_size=args.chunk_size)
            print(f"✅ {t} -> {out_file}")
            successes.append(out_file)
        except Exception as exc:
            print(f"❌ {t}: {exc}", file=sys.stderr)
            failures.append(t)

    elapsed = (datetime.datetime.now() - started).total_seconds()
    print(f"Hecho en {elapsed:.1f}s. OK: {len(successes)} / FAIL: {len(failures)}")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())








