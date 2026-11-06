"""Run every query in ./sql against olist.db and save the results to ./results/*.csv.
The dashboard reads these small CSVs, so it can be deployed without the big database."""
import sqlite3
from pathlib import Path

import pandas as pd

Path("results").mkdir(exist_ok=True)
con = sqlite3.connect("olist.db")
for f in sorted(Path("sql").glob("*.sql")):
    df = pd.read_sql_query(f.read_text(), con)
    df.to_csv(Path("results") / f"{f.stem}.csv", index=False)
    print(f"\n=== {f.stem} ({len(df)} rows) ===")
    print(df.head(5).to_string(index=False))
con.close()
