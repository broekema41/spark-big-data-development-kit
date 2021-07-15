#!/usr/bin/env bash
source ~/.bashrc

project spark

header "Spark"
show_command "spark-show-services" "Show services namespace spark"
show_command "spark-namespace" "create namespace spark"
show_command "spark-start" "Start the 'airflow' helm project"
show_command "spark-stop" "Stop the 'airflow' helm project"
show_command "spark-restart" "Restart the 'airflow' helm project"
