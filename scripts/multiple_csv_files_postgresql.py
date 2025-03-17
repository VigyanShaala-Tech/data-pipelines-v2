import os
import pandas as pd
from sqlalchemy import create_engine

HOST = "localhost"
DATABASE_NAME = "testing_server"
USER = "postgres"
PASSWORD = "arjun123@"
PORT = "5432" 

# Creating sqlalchamy engine
engine = create_engine(f"postgresql+psycopg2://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE_NAME}")

# Upload folder path
folder_path = input()
files = os.listdir(folder_path)

for file in files:
    if file.endswith(".csv"):
        file_path = os.path.join(folder_path, file)

    # Generating table names from first name of the file
        table_name = file.rsplit(".", 1)[0].replace(" ", "_").lower()
        df = pd.read_csv(file_path)

        df.to_sql(table_name, engine, if_exists="fail", index=False)
        print(f"Table {table_name} created and data inserted from {file_path}")





