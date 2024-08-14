# Istio EKS POC

This Proof of Concept (POC) demonstrates how to install Istio on an Amazon EKS cluster and configure secure communication between two deployments using Istio's capabilities.

## Prerequisites

- An existing Amazon EKS cluster
- kubectl configured to communicate with your EKS cluster
- Helm 3 installed

## Installation

- **Install Istio:**

`
cd istio-installation
chmod +x install-istio.sh
./install-istio.sh
`

- **Deploy the demonstration components:**

`
cd ../helm-chart
helm install istio-demo .
`

## Installation

- **Get the pod names:**

`
export POD_A=$(kubectl get pod -l app=service-a -o jsonpath='{.items[0].metadata.name}')
`
`
export POD_B=$(kubectl get pod -l app=service-b -o jsonpath='{.items[0].metadata.name}')
`

- **Exec into Pod A and call Service B:**

`
kubectl exec -it $POD_A -c service-a -- curl http://service-b
`
*You should receive a response from Service B.*

- **Verify the mTLS encryption:**

`
istioctl proxy-config log $POD_A --level debug
`
*Look for log entries indicating TLS handshake and encrypted communication*


## Cleaning Up

`
istioctl manifest generate --set profile=demo | kubectl delete -f -
`
