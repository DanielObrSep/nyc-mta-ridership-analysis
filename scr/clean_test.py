import sys
from pathlib import Path

import pandas as pd
import pytest

sys.path.append(str(Path(__file__).resolve().parents[1] / "scr"))
import clean_data as mod  # noqa: E402

duckdb = pytest.importorskip("duckdb", reason="DuckDB requerido para este test")


def make_raw_df() -> pd.DataFrame:
    cols = [
        "Date",
        "Subways - Total Estimated Ridership",
        "Buses - Total Estimated Ridership",
        "LIRR - Total Estimated Ridership",
        "Metro North - Total Estimated Ridership",
        "Access-A-Ride - Total Scheduled Trips",
        "Bridges and Tunnels - Total Traffic",
        "Staten Island Railway - Total Estimated Ridership",
        "Subways % of Comparable Pre-Pandemic Day",
        "Buses % of Comparable Pre-Pandemic Day",
        "LIRR % of Comparable Pre-Pandemic Day",
        "Metro North % of Comparable Pre-Pandemic Day",
        "Access-A-Ride % of Comparable Pre-Pandemic Day",
        "Bridges and Tunnels % of Comparable Pre-Pandemic Day",
        "Staten Island Railway % of Comparable Pre-Pandemic Day",
    ]

    data = [
        [
            "2020-05-01", 100, 200, 300, 400, 500, 600, 700,
            50, 60, 70, 80, 90, 55, 66,
        ],
        [
            "2020-05-02", 10, 20, 30, 40, 50, 60, 70,
            0, 0, 0, 0, 0, 0, 0,
        ],
        [
            "not-a-date", 1, 2, 3, 4, 5, 6, 7,
            10, 11, 12, 13, 14, 15, 16,
        ],
    ]
    return pd.DataFrame(data, columns=cols)

def test_sanitized_columns_basic():
    df = pd.DataFrame({
        "Fecha del Día": [1],
        "Estación #12": [2],
        "Subways - Total Estimated Ridership": [3],
        "Buses % of Comparable Pre-Pandemic Day": [4],
    })
    out = mod.sanitized_columns(df)
    assert list(out.columns) == [
        "fecha_del_dia",
        "estacion_12",
        "subways_total_estimated_ridership",
        "buses_%_of_comparable_pre_pandemic_day",
    ]

def test_clean_mta_daily_types_and_filtering():
    raw = make_raw_df()
    snaked = mod.sanitized_columns(raw)
    clean = mod.clean_mta_daily(snaked)

    assert clean.shape[0] == 1
    assert clean["date"].iloc[0] == "2020-05-01"

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

    for c in columns_int:
        assert pd.api.types.is_integer_dtype(clean[c].dtype)
    for c in columns_float:
        assert pd.api.types.is_integer_dtype(clean[c].dtype)


def test_sanitized_ident_ok_and_fail():
    assert mod.sanitized_ident("tabla_1") == "tabla_1"
    with pytest.raises(ValueError):
        mod.sanitized_ident("tabla-mala!")

def test_save_duckdb_replace_and_append(tmp_path):
    df = mod.clean_mta_daily(mod.sanitized_columns(make_raw_df()))
    db = tmp_path / "test.duckdb"

    tname = mod.save_duckdb(df, db_path=db, table="t_prueba", mode="replace")
    assert tname == "t_prueba"

    with duckdb.connect(str(db)) as con:
        tables = con.sql(
            "SELECT table_schema, table_name "
            "FROM information_schema.tables "
            "WHERE table_schema='main'"
        ).fetchdf()
        cnt = con.sql("SELECT COUNT(*) AS c FROM main.t_prueba").fetchone()[0]
        assert cnt == len(df), f"Tablas visibles:\n{tables}"

    mod.save_duckdb(df, db_path=db, table="t_prueba", mode="append")
    with duckdb.connect(str(db)) as con:
        cnt2 = con.sql("SELECT COUNT(*) AS c FROM main.t_prueba").fetchone()[0]
        assert cnt2 == 2 * len(df)
