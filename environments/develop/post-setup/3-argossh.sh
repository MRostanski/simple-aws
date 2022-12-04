#!/bin/bash

ARGOPASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
argocd login localhost:8080 --username admin --password $ARGOPASS --insecure
argocd repo add git@bitbucket.org:cobrick/fatty-k8s-cluster.git --ssh-private-key-path ./cluster-setup.key