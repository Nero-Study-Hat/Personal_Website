# Read the contents of a local file
module "iam_role-dev-personal-website" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role"
    version = "6.4.0"

    name = "dev-personal-website"

    enable_github_oidc = true
    oidc_subjects = ["repo:Nero-Study-Hat/Personal_Website:ref:refs/heads/mvp"]
    oidc_audiences = ["sts.amazonaws.com"]

    policies = {
        dev-personal-website = aws_iam_policy.dev-personal-website.arn
    }

    tags = {
        Environment = var.environment
        Project     = var.project
    }
}

data "aws_iam_policy_document" "dev-personal-website" {
    statement {
        sid = "Terraform"

        actions = [
            "ec2:*",
            "s3:*",
            "dynamodb:*",
            "elasticloadbalancing:*"
        ]

        resources = [
            "*"
        ]

        condition {
            test     = "StringEquals"
            variable = "aws:ResourceTag/Project"

            values = [
                "Personal-Website"
            ]
        }
    }
}

resource "aws_iam_policy" "dev-personal-website" {
    name   = "dev-personal-website"
    description = "Policy for managing all Project:Personal-Website resources"
    path   = "/"
    policy = data.aws_iam_policy_document.dev-personal-website.json

    tags = {
        Environment = var.environment
        Project     = var.project
    }
}