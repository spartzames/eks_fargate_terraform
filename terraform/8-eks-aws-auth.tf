# Datasource: 
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token 
}

output "cluster_id" {
  description = "The name/id of the EKS cluster."
  value       = aws_eks_cluster.cluster.id
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

# Pull AWS Account ID
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Locals Block
locals {
  configmap_roles = [
    {
      rolearn = "arn:aws:iam::789535401130:role/CCOE"
      username = "ccoe"
      groups = ["system:masters"]
    },
    {
      rolearn = "${aws_iam_role.eks-fargate-profile.arn}"
      username = "system:node:{{SessionName}}"
      groups = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
    },
  ]
  configmap_users = [
    {
      userarn = "${aws_iam_user.basic_user.arn}"
      username = "${aws_iam_user.basic_user.name}"
      groups = ["system:masters"]
    },
  ]
}

# Kubernetes Config Map
resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [aws_eks_cluster.cluster]
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(local.configmap_roles)
    mapUsers = yamlencode(local.configmap_users)
  }
}