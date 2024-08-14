#!/bin/bash

# Download Istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.18.2 sh -

# Move to Istio directory
cd istio-1.18.2

# Add istioctl to PATH
export PATH=$PWD/bin:$PATH

# Install Istio with demo profile
istioctl install --set profile=demo -y

# Enable automatic sidecar injection for default namespace
kubectl label namespace default istio-injection=enabled

# Verify installation
kubectl get pods -n istio-system