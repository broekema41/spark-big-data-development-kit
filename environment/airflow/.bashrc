alias airflow-show-services="watch 'kubectl get all,cm -n airflow; echo Press Ctrl-C to exit'"
alias airflow-namespace="kubectl create namespace airflow"
alias airflow-start=". ~/.bashrc && helm install -n airflow airflow /vagrant/helm/airflow"
alias airflow-stop='helm delete -n airflow airflow'
alias airflow-restart='airflow-stop; airflow-start'


