#!/usr/bin/env bash
source ~/.bashrc

project Generic
header Commands
show_command "pleh" "Show help"

header "Various functions"
show_command "clean-images" "Remove all unused images from disk, forcing Docker/Kubernetes to download again"
show_command "show-pods" "Show state of all pods in k8s (Ctrl-C to exit)"
show_command "show-services" "Show state of all components in k8s (Ctrl-C to exit)"

header "Shared-services"
show_command "reverseproxy-start" "Start the 'reverseproxy' helm project"
show_command "reverseproxy-stop" "Stop the 'reverseproxy' helm project"
show_command "reverseproxy-restart" "Restart the 'reverseproxy' helm project"
show_command "reverseproxy-tail" "Tail the logs of the 'reverseproxy' application"
