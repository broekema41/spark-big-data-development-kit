alias spark-show-services="watch 'kubectl get all,cm -n spark; echo Press Ctrl-C to exit'"
alias spark-namespace="kubectl create namespace spark"
alias spark-start=". ~/.bashrc && helm install -n spark spark /vagrant/helm/spark"
alias spark-stop='helm delete -n spark spark'
alias spark-restart='spark-stop; spark-start'
