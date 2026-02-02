from datetime import datetime

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

with DAG(
    dag_id="northwind_test",
    start_date=datetime(2026, 1, 1),
    schedule=None,   # manual run for now
    catchup=False,
    tags=["northwind", "smoke-test"],
) as dag:

    count_customers = PostgresOperator(
        task_id="count_customers",
        postgres_conn_id="northwind_pg",
        sql="""
        select count(*) as customer_count
        from webshop.customer;
        """,
    )
