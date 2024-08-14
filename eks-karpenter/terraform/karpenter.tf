module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  create_iam_role = false
}

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["on-demand"]
    - key: kubernetes.io/arch
      operator: In
      values: ["amd64", "arm64"]
  limits:
    resources:
      cpu: 1000
  provider:
    instanceTypes: ["t3.medium", "t4g.medium"]
  ttlSecondsAfterEmpty: 30
YAML

  depends_on = [module.karpenter]
}