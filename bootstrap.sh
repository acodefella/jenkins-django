#!/bin/bash

## Prerequites 
## Run only on Linux

## Emit text in colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Creating installation dir${reset}"
[ -d ~/bin ] || mkdir ~/bin
export PATH=~/bin:$PATH

echo "${green}Installing kubectl${reset}"
curl -sLo /tmp/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x /tmp/kubectl
mv -n /tmp/kubectl ~/bin/kubectl
chmod +x ~/bin/kubectl

echo "${green}Installing kind${reset}"
curl -sLo /tmp/kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x /tmp/kind
mv -n /tmp/kind ~/bin/kind

echo "${green}Creating k8s cluster${reset}"
kind create cluster                \
     --name django-cluster         \
     --config ./kind.config        \
     --wait 5m                     \
     --kubeconfig ./django.config

echo "${green}Installing helm${reset}"
curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 /tmp/get_helm.sh
export HELM_INSTALL_DIR=~/bin
/tmp/get_helm.sh --no-sudo

## set kubeconfig for all upcoming operations
export KUBECONFIG=./django.config

echo "${green}Deploying Ingress NGINX${reset}"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx              \
  --for=condition=ready pod                         \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "${green}Deploying Jenkins${reset}"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade                     \
  --install jenkins-release      \
  --values jenkins/values.yaml   \
  --namespace jenkins            \
  --create-namespace             \
  bitnami/jenkins

echo "127.0.0.1    jenkins.local"   >> /etc/hosts
## At this point, access jenkins using http://jenkins.local url

echo "${green}Deploying Postgres${reset}"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade                     \
  --install postgres             \
  --values db/values.yaml        \
  --namespace app                \
  --create-namespace             \
  bitnami/postgresql

## App deployment 