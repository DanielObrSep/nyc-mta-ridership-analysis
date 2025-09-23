import argparse
import re
import unicodedata
from pathlib import Path

import pandas as pd

try:
    import duckdb
except ImportError:
    duckdb = None

# -------- Utilities ----------


def info(msg: str) -> None:
    print(f"[info]{msg}")


def fail_if_not_path(path: Path) -> None:
    if not path.exists():
        raise ValueError(f"Path dont exist {path}")


def ensure_path(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def sanitized_ident(name: str) -> str:
    if not re.fullmatch("[A-Za-z_][A-Za-z0-9_]*", name):
        raise ValueError(f"Invalid name {name}")
    return name


# ------ Snake collumns --------


def sanitized_columns(df: pd.DataFrame) -> pd.DataFrame:
    def to_snake(name: str) -> str:
        if name is None:
            return ""
        s = str(name).strip()
        s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
        s = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", s)
        s = re.sub(r"([A-Z]+)([A-Z][a-z0-9])", r"\1_\2", s)
        s = re.sub(r"([a-zA-Z])([0-9])", r"\1_\2", s)
        s = re.sub(r"([0-9])([a-zA-Z])", r"\1_\2", s)
        s = re.sub(r"[^A-Za-z0-9%]+", "_", s)
        s = s.lower()
        s = s.strip()
        s = re.sub(r"_+_", "_", s).strip("_")
        return s

    out = df.copy()
    out.columns = [to_snake(c) for c in out.columns]
    return out


# ------------ clean ------------


def clean_mta_daily(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()

    out["date"] = pd.to_datetime(out["date"], errors="coerce")
    out = out[out["date"].notna()]
    out["date"] = out["date"].dt.strftime("%Y-%m-%d")

    columns_int = [
        "subways_total_estimated_ridership",
        "buses_total_estimated_ridership",
        "lirr_total_estimated_ridership",
        "metro_north_total_estimated_ridership",
        "access_a_ride_total_scheduled_trips",
        "bridges_and_tunnels_total_traffic",
        "staten_island_railway_total_estimated_ridership",
    ]

    columns_float = [
        "subways_%_of_comparable_pre_pandemic_day",
        "buses_%_of_comparable_pre_pandemic_day",
        "lirr_%_of_comparable_pre_pandemic_day",
        "metro_north_%_of_comparable_pre_pandemic_day",
        "access_a_ride_%_of_comparable_pre_pandemic_day",
        "bridges_and_tunnels_%_of_comparable_pre_pandemic_day",
        "staten_island_railway_%_of_comparable_pre_pandemic_day",
    ]

    out[columns_int] = (
        out[columns_int].apply(pd.to_numeric, errors="coerce").astype("Int64")
    )

    out[columns_float] = (
        out[columns_float]
        .apply(pd.to_numeric, errors="coerce")
        .mask(lambda x: x == 0)
        .astype("Int64")
    )

    out = out[out[columns_float + columns_int + ["date"]].notna().all(axis=1)]

    return out


# ----------- duckdb -------------------


def save_duckdb(
    df: pd.DataFrame,
    db_path: Path,
    table: str | None = None,
    mode: str | None = None,
    layer: str = "clean",
) -> str:
    if duckdb is None:
        info("Duckdb no available, omit duckdb")
        return "Duckdb no available"

    if table is None:
        table = f"{layer}_data"
    else:
        table = sanitized_ident(table)

    ensure_path(db_path)
    with duckdb.connect(str(db_path)) as con:
        con.register("df_clean", df)
        if mode == "replace":
            con.execute(f"CREATE OR REPLACE TABLE {table} AS SELECT * FROM df_clean")
        elif mode == "append":
            con.execute(
                f"CREATE TABLE IF NOT EXISTS {table} AS SELECT * FROM df_clean WHERE 1=0"
            )
            con.execute(f"Insert into {table} Select * From df_clean")
        else:
            raise ValueError("Mode most be 'append' or 'replace'")

    info(f"Table {table} in {db_path}")
    return table


# ------------ commands ----------------


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description=" Cleaning csv-raw to csv-clean")

    p.add_argument("--in", dest="input", required=True, help="Path input data")
    p.add_argument("--out", dest="output", required=True, help="Path output data")
    p.add_argument(
        "--duckdb", dest="duckdb_path", default=None, help="Path to save duckdb"
    )
    p.add_argument(
        "--mode",
        dest="mode",
        choices=["append", "replace"],
        default="replace",
        help="Mode duckdb",
    )
    return p.parse_args()


# ----------------- main ------------------


def main() -> None:
    args = parse_args()
    input = Path(args.input).resolve()
    output = Path(args.output).resolve()

    if not input.exists():
        raise ValueError(f"Does not exist {input}")
    if input.suffix.lower() in (".xlsx", ".xls"):
        df = pd.read_excel(input)
    else:
        df = pd.read_csv(input)

    df = sanitized_columns(df)

    info(f"Previus cleaning | rows= {df.shape[0]}, columns= {df.shape[1]}")

    df_clean = clean_mta_daily(df)

    info(f"Post cleaning | rows= {df_clean.shape[0]} cols= {df_clean.shape[1]}")

    ensure_path(output)
    df_clean.to_csv(output, index=False, encoding="utf-8-sig")
    info(f"Csv written to: {output}")

    if args.duckdb_path is not None:
        save_duckdb(df_clean, db_path=Path(args.duckdb_path).resolve(), mode=args.mode)

    info("End")


if __name__ == "__main__":
    main()
