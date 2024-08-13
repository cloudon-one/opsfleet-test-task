
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
import logging

def hello_world():
    logging.info("Hello, Airflow on Kubernetes!")

def check_airflow_components():
    logging.info("Checking Airflow components on Kubernetes...")
    return "All components are up and running!"

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 8, 1),
    'email': ['admin@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'demo_dag',
    default_args=default_args,
    description='A simple demo DAG to test Airflow on Kubernetes',
    schedule_interval=timedelta(days=1),
    catchup=False,
) as dag:

    # Task 1: Print Hello World
    task_hello_world = PythonOperator(
        task_id='hello_world',
        python_callable=hello_world
    )

    # Task 2: Bash Task - List files in the working directory
    task_list_files = BashOperator(
        task_id='list_files',
        bash_command='ls -l'
    )

    # Task 3: Python Task - Check Airflow Components
    task_check_components = PythonOperator(
        task_id='check_airflow_components',
        python_callable=check_airflow_components
    )

    # Define task dependencies
    task_hello_world >> task_list_files >> task_check_components
