#!/bin/bash

wget https://github.com/linkerd/linkerd2/releases/download/stable-2.10.2/linkerd2-cli-stable-2.10.2-linux-amd64
mv linkerd2-cli-stable-2.10.2-linux-amd64 linkerd && chmod +x linkerd
./linkerd install | kubectl apply -f -
./linkerd viz install | kubectl apply -f -
