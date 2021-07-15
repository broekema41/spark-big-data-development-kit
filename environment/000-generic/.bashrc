#!/bin/bash

RESET="\e[0m"
NORMAL="\e[21m\e[39m"
BOLD="\e[1m\e[92m"
BLUE="\e[94m"
RED="\e[91m"
DOCKER_REPO="registry.haw.vodafone.nl"
IMAGE_NAME=

function project {

  echo -e "\n\n${RED}====================="
  echo -e "  $@"
  echo -e "=====================${RESET}"
}

function header {
  printf "\n%-2s%b%s%b\n" "" "${BLUE}" "$@" "${RESET}"
}

function show_command {
  printf "%-4s%b%-50s%b%s\n" "" "${BOLD}" "${1}" "${RESET}" "${2}"
}



function docker-analyse-size {
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $1
}

function pleh {
  find /vagrant/environment/$1 -name pleh.sh | sort | xargs -i bash {}
}
alias help='pleh'
alias clean-images="docker image prune -af"
alias show-pods="watch 'kubectl get pods --all-namespaces; echo; echo Press Ctrl-C to exit'"
alias show-services="watch 'kubectl get all,cm --all-namespaces; echo; echo Press Ctrl-C to exit'"

alias reverseproxy-start='. ~/.bashrc && helm install reverseproxy /vagrant/helm/reverseproxy'
alias reverseproxy-stop='helm delete reverseproxy'
alias reverseproxy-restart='reverseproxy-stop; reverseproxy-start'
alias reverseproxy-tail='kubectl logs -f --tail=100 --selector="name=reverseproxy"'

function _tail_pod() {
    app="${1}"
    lines=${2:-100}
    container=${3:-placeholder_not_specified}
    if [[ $container != "placeholder_not_specified" ]]
    then
      kubectl logs -f --tail=${lines} --selector="app=${app}" -c "${container}"
    else
      kubectl logs -f --tail=${lines} --selector="app=${app}"
    fi
}
