resource "aws_iam_user" "dev_user" {
  name = "${var.project_name}-dev-readonly"
}

resource "aws_iam_access_key" "dev_user_key" {
  user = aws_iam_user.dev_user.name
}

# Minimal policy allowing EKS read/list/describe actions
data "aws_iam_policy_document" "eks_readonly" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:ListUpdates",
      "eks:DescribeUpdate",
      "ec2:Describe*",
      "cloudwatch:Describe*",
      "logs:Describe*",
      "logs:GetLogEvents",
      "s3:ListBucket"  # optional if you keep logs in S3
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_readonly_policy" {
  name   = "${var.project_name}-eks-readonly"
  policy = data.aws_iam_policy_document.eks_readonly.json
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.dev_user.name
  policy_arn = aws_iam_policy.eks_readonly_policy.arn
}

output "dev_iam_access_key_id" {
  value = aws_iam_access_key.dev_user_key.id
  sensitive = true
}

output "dev_iam_secret_access_key" {
  value = aws_iam_access_key.dev_user_key.secret
  sensitive = true
}

