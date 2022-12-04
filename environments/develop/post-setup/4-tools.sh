#!/bin/bash

# go to fatty-k8scluster argocd!
kubectl apply -f argo/prometheus-operator.yaml
kubectl apply -f argo/prometheus.yaml
kubectl apply -f grafana.yaml
kubectl apply -f argo/kube-state-metrics.yaml
kubectl apply -f socks-shop.yaml
kubectl apply -f monitoring-misc.yaml
kubectl apply -f keda.yaml
kubectl apply -f scalers-yamls.yaml
kubectl apply -f metrics-agent.yaml
kubectl apply -f loadtest.yaml