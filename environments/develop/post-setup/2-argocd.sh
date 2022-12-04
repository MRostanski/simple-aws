#!/bin/bash

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# annotate the argocd-server service:
#   service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
#   service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
#   service.beta.kubernetes.io/aws-load-balancer-type: external 