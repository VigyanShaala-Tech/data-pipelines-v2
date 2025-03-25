import os
import sys
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

def load_env(file_path):
    load_dotenv(file_path)
    return {
        'HOST' : os.getenv("DB_HOST"),
        'DB_NAME' : os.getenv("DB_NAME"),
        'USER' : os.getenv("DB_USER"),
        'PASSWORD': os.getenv("DB_PASSWORD"),
        'PORT' : os.getenv("DB_PORT")
        }

def loading_engine(config):
    return(create_engine(f"postgresql+psycopg2://{config['USER']}:{config['PASSWORD']}@{config['HOST']}:{config['PORT']}/{config['DB_NAME']}"))

def import_csv_to_db(folder_path, engine):
    files = os.listdir(folder_path)
    for file in files:
        if file.endswith(".csv"):
            file_path = os.path.join(folder_path, file)
            table_name = file.rsplit(".", 1)[0].replace(" ", "_").lower()
            df = pd.read_csv(file_path)
            df.to_sql(table_name, engine, if_exists="fail", index=False)
            print(f"Table '{table_name}' created and data inserted from '{file_path}'")

folder_path = sys.argv[1]
config = load_env("config.env")
engine = loading_engine(config)
import_csv_to_db(folder_path, engine)

