from sqlalchemy import create_engine

def get_engine():
    server = r"DESKTOP-BOB36MT\DAT"
    database = "Sleep_health"

    engine = create_engine(
        f"mssql+pyodbc://@{server}/{database}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"
    )
    return engine