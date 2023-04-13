output "cluster_id" {
  value = aws_eks_cluster.kthong-cluster.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.kthong-cluster.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.kthong-cluster.certificate_authority[0].data
}

# Pull AWS Account ID
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}