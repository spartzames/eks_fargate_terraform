# AWS IAM User - Admin User with Full AWS Access
resource "aws_iam_user" "basic_user" {
  name = "kthong-eks-basic-01"  
  path = "/"
  force_destroy = true
}

# Resource: AWS IAM User Policy - EKS Full Access
resource "aws_iam_user_policy" "basic_user_eks_policy" {
  name = "kthong-eks-full-access-policy"
  user = aws_iam_user.basic_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

locals {
  configmap_roles = [
    {
      #rolearn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.eks_nodegroup_role.name}"
      rolearn = "arn:aws:iam::789535401130:role/CCOE"
      username = "ccoe"
      groups = ["system:masters"]
    },
    {
      rolearn = "${aws_iam_role.eks-fargate-profile.arn}"
      username = "system:node:{{SessionName}}"
      groups = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
    }
  ]
  configmap_users = [
    {
      userarn = "${aws_iam_user.basic_user.arn}"
      username = "${aws_iam_user.basic_user.name}"
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
