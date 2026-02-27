# python/load_bronze.py
"""
Carga inicial y actualización de datos desde Cloud Storage a BigQuery
Bronze Layer
"""

from google.cloud import bigquery
from datetime import datetime

PROJECT_ID = "edibs-marketing-analytics"
DATASET_ID = "bronze"
BUCKET = "edibs-marketing-data"

def load_table(client, table_name, file_name):
    """Carga una tabla desde Cloud Storage"""
    table_id = f"{PROJECT_ID}.{DATASET_ID}.{table_name}"
    uri = f"gs://{BUCKET}/bronze/{file_name}"
    
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,
        write_disposition="WRITE_TRUNCATE"  # Sobrescribe la tabla
    )
    
    load_job = client.load_table_from_uri(uri, table_id, job_config=job_config)
    load_job.result()
    
    table = client.get_table(table_id)
    print(f"✅ {table_name}: {table.num_rows} filas cargadas")
    return table.num_rows

def main():
    """Carga todas las tablas del Bronze Layer"""
    print(f"🚀 Iniciando carga de datos - {datetime.now()}")
    
    client = bigquery.Client(project=PROJECT_ID)
    
    tables = [
        ("clients", "Clients_Enhanced.csv"),
        ("campaigns", "Campaigns_Enhanced.csv"),
        ("products", "Products_Enhanced.csv"),
        ("sales", "Sales_Enhanced.csv"),
        ("ads_daily", "Ads_Daily_Enhanced.csv"),
    ]
    
    total_rows = 0
    for table_name, file_name in tables:
        rows = load_table(client, table_name, file_name)
        total_rows += rows
    
    print(f"\n🎉 Carga completada: {total_rows} filas totales")
    print("💡 Las transformaciones Silver/Gold deben ejecutarse ahora")

if __name__ == "__main__":
    main()