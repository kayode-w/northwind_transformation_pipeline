import os
from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount

DBT_IMAGE = "local/dbt-postgres:latest"
DOCKER_NETWORK = "airflow_dbt_postgres_elt_net"  # docker network ls

# MUST be the HOST path (Mac path). Docker daemon uses it for bind mounts.
PROJECT_ROOT = os.environ["PROJECT_ROOT"]

DBT_PROJECT_MOUNT = Mount(
    source=f"{PROJECT_ROOT}/dbt/northwind_transformations",
    target="/usr/app/northwind_transformations",
    type="bind",
)

DBT_PROFILES_MOUNT = Mount(
    source=f"{PROJECT_ROOT}/dbt/.dbt",
    target="/root/.dbt",
    type="bind",
)

default_args = {
    "retries": 2,
    "retry_delay": timedelta(minutes=3),
}

with DAG(
    dag_id="dbt_transformation_trigger",
    start_date=datetime(2026, 1, 1),
    schedule="0 1 * * *",   # daily 01:00 UTC (change later if you want)
    catchup=False,
    default_args=default_args,
    tags=["northwind", "dbt"],
) as dag:

    dbt_deps = DockerOperator(
        task_id="dbt_deps",
        image=DBT_IMAGE,
        docker_url="unix://var/run/docker.sock",
        network_mode=DOCKER_NETWORK,
        auto_remove=True,

        mount_tmp_dir=False,          # avoids the /tmp bind mount issue on Mac
        working_dir="/usr/app/northwind_transformations",

        entrypoint=["dbt"],           
        command="deps",

        mounts=[DBT_PROJECT_MOUNT, DBT_PROFILES_MOUNT],
        do_xcom_push=False,
    )

    dbt_run_staging = DockerOperator(
        task_id="dbt_run_staging",
        image=DBT_IMAGE,
        docker_url="unix://var/run/docker.sock",
        network_mode=DOCKER_NETWORK,
        auto_remove=True,

        mount_tmp_dir=False,
        working_dir="/usr/app/northwind_transformations",

        entrypoint=["dbt"],
        command="run --select staging",

        mounts=[DBT_PROJECT_MOUNT, DBT_PROFILES_MOUNT],
        do_xcom_push=False,
    )

    dbt_test_staging = DockerOperator(
        task_id="dbt_test_staging",
        image=DBT_IMAGE,
        docker_url="unix://var/run/docker.sock",
        network_mode=DOCKER_NETWORK,
        auto_remove=True,

        mount_tmp_dir=False,
        working_dir="/usr/app/northwind_transformations",

        entrypoint=["dbt"],
        command="test --select staging",

        mounts=[DBT_PROJECT_MOUNT, DBT_PROFILES_MOUNT],
        do_xcom_push=False,
    ), 

    dbt_run_marts = DockerOperator(
        task_id="dbt_run_marts",
        image=DBT_IMAGE,
        docker_url="unix://var/run/docker.sock",
        network_mode=DOCKER_NETWORK,
        auto_remove=True,

        mount_tmp_dir=False,
        working_dir="/usr/app/northwind_transformations",

        entrypoint=["dbt"],
        command="run --select marts",

        mounts=[DBT_PROJECT_MOUNT, DBT_PROFILES_MOUNT],
        do_xcom_push=False,
    )

    dbt_deps >> dbt_run_staging >> dbt_test_staging >> dbt_run_marts