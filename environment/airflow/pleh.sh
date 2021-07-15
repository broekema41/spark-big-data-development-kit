#!/usr/bin/env bash
source ~/.bashrc

project airflow

header "Airflow"
show_command "airflow-show-services" "Show services namespace spark"
show_command "airflow-namespace" "create namespace airflow"
show_command "airflow-start" "Start the 'airflow' helm project"
show_command "airflow-stop" "Stop the 'airflow' helm project"
show_command "airflow-restart" "Restart the 'airflow' helm project"
