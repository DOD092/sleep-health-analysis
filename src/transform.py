import pandas as pd 
import sqlite3


csv_file="../dataset/raw/Sleep_health_and_lifestyle_dataset.csv"
db = "../raw/sleep_health.db"
db_file="../dataset/raw/sleep_health.db"
table_name="sleep_health"

try:
    df=pd.read_csv(csv_file)
    conn=sqlite3.connect(db_file)
    df.to_sql(table_name, conn, if_exists="replace", index=False)

    print(f"Done: {db_file}")
    print(f"Table name: {table_name}")
    print(f"Columns name:")
    print(df.columns.tolist())

    conn.close()

except Exception as e:
    print("Error", e)