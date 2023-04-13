# AWS IAM User - Admin User with Full AWS Access
resource "aws_iam_user" "kthong_admin_user" {
  name = "kthong-eks-admin-01"  
  path = "/"
  force_destroy = true
}

locals {
  configmap_roles = [
    {
      rolearn = "${aws_iam_role.eks-kthong-cluster.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = ["system:bootstrappers", "system:nodes"]
    }
  ]
  configmap_users = [
    {
      userarn = "${aws_iam_user.kthong_admin_user.arn}"
      username = "${aws_iam_user.kthong_admin_user.name}"
      groups = ["system:masters"]
    }
  ]
}

resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [
    aws_eks_cluster.kthong-cluster
  ]
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    "mapRoles" = "yamlencode(local.configmap_roles)"
    "mapUsers" = "yamlencode(local.configmap_users)"
  }
}
