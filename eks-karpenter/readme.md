# EKS Cluster with Karpenter

This Terraform configuration deploys an Amazon EKS cluster with Karpenter for autoscaling, supporting both x86 and arm64 (Graviton) instances.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.5 or later)
- kubectl installed
- An existing VPC in your AWS account

## Usage

**Clone repository:** 

`
git clone https://github.com/cloudon-one/opsfleet-test-task.git && cd eks-karpenter/terraform
`

**Initialize Terraform:**

`
terraform init
`

`
terraform apply
`

**After the cluster is created, configure kubectl:**

`
aws eks get-token --cluster-name demo-cluster
`


- Karpenter will automatically provision the appropriate instance types based on the node selectors.

