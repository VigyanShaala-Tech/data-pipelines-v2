import warnings
warnings.filterwarnings('ignore')
from sqlalchemy import create_engine
import pandas as pd

def csv_to_mysql_loading(csv_path, table_name, db_host, db_user, db_password, db_port_no, db_schema_name):
    db_destination_link = f"mysql+mysqldb://{db_user}:{db_password}@{db_host}:{db_port_no}/{db_schema_name}"
    engine = create_engine(db_destination_link)
    conn = engine.connect()
    data = pd.read_csv(csv_path)
    data.to_sql(table_name, engine, index=False, if_exists='replace')
    
    conn.close()
    return f"Data successfully imported into table '{table_name}'."

data_set_path_link = input()
table_name = input()
db_host = input()
db_port = input()
db_name = input()
db_user = input()
db_password = input()
result = csv_to_mysql_loading(data_set_path_link, table_name, db_host, db_port, db_name, db_user, db_password)
print(result)
