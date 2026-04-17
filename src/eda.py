import pandas as pd
from db_connection import get_engine
engine=get_engine()

engine = get_engine()

query = """
SELECT TOP 10 *
FROM dbo.Sleep_health_and_lifestyle_dataset
"""

df = pd.read_sql(query, engine)

print(df)