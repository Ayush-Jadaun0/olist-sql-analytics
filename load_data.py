"""Load the Olist CSV files from ./data into a SQLite database (olist.db)."""
import sqlite3
from pathlib import Path

import pandas as pd

SKIP = {"olist_geolocation_dataset"}  # large, not needed for these questions

con = sqlite3.connect("olist.db")
for f in sorted(Path("data").glob("*.csv")):
    if f.stem in SKIP:
        continue
    name = f.stem.replace("olist_", "").replace("_dataset", "")
    df = pd.read_csv(f)
    df.to_sql(name, con, if_exists="replace", index=False)
    print(f"loaded {name:35s} {len(df):>8,} rows")
con.close()
