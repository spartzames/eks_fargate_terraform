# Resource: AWS IAM User - Basic User (No AWSConsole Access for AWS Services)
resource "aws_iam_user" "basic_user" {
  name = "kthong-eks-admin-01"  
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