resource "aws_eks_cluster" "kthong-cluster" {
  name = var.cluster_name
  version = var.cluster_version
  role_arn = aws_iam_role.eks-kthong-cluster.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    public_access_cidrs = [ "0.0.0.0/0" ]

    subnet_ids = [
        aws_subnet.private-ap-southeast-2a.id,
        aws_subnet.private-ap-southeast-2b.id,
        aws_subnet.public-ap-southeast-2a.id,
        aws_subnet.public-ap-southeast-2b.id
    ]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.amazon-eks-cluster-policy
  ]
}

# Datasource: 
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.kthong-cluster.id
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = aws_eks_cluster.kthong-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.kthong-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token 
}
