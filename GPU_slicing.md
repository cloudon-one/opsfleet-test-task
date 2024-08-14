## Overview of GPU Slicing

GPU slicing allows different processes or pods to share the resources of a single GPU card. This is particularly useful in cases where your workloads do not fully utilize the capabilities of a GPU. By leveraging GPU slicing, you can ensure better resource utilization and potentially lower costs.

## Benefits of GPU Slicing
- **Cost Efficiency:** 

Utilize underused GPU resources more effectively.

- **Scalability:** 

Enable more workloads to run simultaneously on fewer GPU resources.

- **Flexibility:** Optimize for different workload requirements and adjust slices as needed.

## Enabling GPU Slicing on EKS

To enable GPU slicing on EKS, you need to use NVIDIA’s Multi-Instance GPU (MIG) feature available in the NVIDIA Ampere architecture (A100 GPUs and newer). Here's how you can set it up:

### Prerequisites

- **EKS Cluster:**

Ensure your EKS cluster is running and properly configured.

- **GPU Instance Types:** 

Use AWS GPU instance types that support NVIDIA MIG, such as the **g5**, **g5g**, or **p4d** instance types.

- **NVIDIA Drivers:** 

Ensure you have the latest NVIDIA drivers installed that support MIG.

## Steps to Enable GPU Slicing

**Install the NVIDIA Device Plugin for Kubernetes.** This plugin allows Kubernetes to detect and utilize the GPU resources available on the nodes.

`
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.13.0/deployments/gpu-feature-discovery.yaml
`

**Configure MIG Mode:**

- Connect to your GPU node and enable MIG mode:
`
sudo nvidia-smi -i 0 -mig 1
`

- Configure the desired MIG profile. For example, to create 2 slices of 2 GPU instances each:

`
sudo nvidia-smi mig -cgi 19,19
`

`
sudo nvidia-smi mig -cci
`

**Deploy Pods Using GPU Slices:**

- Update your pod spec to request specific GPU slices:
 ` 
   kubectl apply -f eks-karpenter/manifests/gpu-pod.yaml
   `

## Enabling GPU Slicing with Karpenter Autoscaler  

- Karpenter is a flexible autoscaling solution for Kubernetes. It can be configured to work with GPU slicing by following these steps:

**Install and Configure Karpenter:**

- Follow the official [**Karpenter installation guide**](https://karpenter.sh/v0.37/getting-started/getting-started-with-karpenter/)  to set up Karpenter in your EKS cluster.

**Configure Karpenter Provisioners:**

- Define provisioners in Karpenter that specify the instance types and resources needed.

 ` 
   kubectl apply -f eks-karpenter/manifests/karpenter.yaml
   `

**Deploy Pods with Karpenter:**

- Deploy your pods as usual, and Karpenter will automatically provision nodes with the necessary GPU slices according to the defined provisioners.

## Best Practices

**Monitoring and Logging:** 
- Regularly monitor GPU usage and logs to ensure efficient utilization and troubleshoot any issues.

**Testing:** 
- Start with smaller configurations and gradually scale up to validate the impact on performance and cost savings.

**Up-to-date Software:** 
- Keep your NVIDIA drivers and Kubernetes plugins up to date for the best performance and compatibility.
