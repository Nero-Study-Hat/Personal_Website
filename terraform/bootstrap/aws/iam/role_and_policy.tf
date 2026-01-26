module "iam_role-iam-controller" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role"
    version = "6.4.0"

    name = "iam-controller"

    trust_policy_permissions = {
        TrustUsersToAssume = {
            actions = [
                "sts:AssumeRole",
                "sts:TagSession",
            ]
            // more strict, needs terraform re-run to add new users
            // and sets explicit trust relationship here that user must
            // be in the iam-controller group, not just role assume permission
            principals = [{
                type = "AWS"
                # identifiers = module.iam_group-iam-controllers.users[*]
                identifiers = [
                for user in module.iam_group-iam-controllers.users :
                    "arn:aws:iam::${var.account_id}:user/${user}"
                ]
            }]
        }
    }

    policies = {
        iam-controller = aws_iam_policy.iam-controller.arn
    }

    tags = {
        Terraform = true
    }
}

data "aws_iam_policy_document" "iam-controller" {
    statement {
        sid = "IAMControllerTerraform"
        // copied IAMFullAccess managed policy
        actions = [
            "iam:*",
            "organizations:DescribeAccount",
            "organizations:DescribeOrganization",
            "organizations:DescribeOrganizationalUnit",
            "organizations:DescribePolicy",
            "organizations:ListChildren",
            "organizations:ListParents",
            "organizations:ListPoliciesForTarget",
            "organizations:ListRoots",
            "organizations:ListPolicies",
            "organizations:ListTargetsForPolicy"
        ]
        resources = ["*"]
    }
    // need StateBackendAccess here declared for user permissions
    // because assume_role is not working with backend config
    statement {
        sid = "StateBackendAccess"
        // copied IAMFullAccess managed policy
        actions = [
                "s3:CreateBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:GetBucketLocation"
        ]
        resources = [
            "arn:aws:s3:::terraform-state-backend-0iw5ulc1",
            "arn:aws:s3:::terraform-state-backend-0iw5ulc1/*"
        ]
    }
}

resource "aws_iam_policy" "iam-controller" {
    name   = "iam-controller"
    description = "Policy for managing all Account:IAM resources"
    path   = "/"
    policy = data.aws_iam_policy_document.iam-controller.json

    tags = {
        Terraform = true
    }
}


module "iam_role-dev-personal-website" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role"
    version = "6.4.0"

    name = "dev-personal-website"

    # TrustGithubActionsToAssume
    enable_github_oidc = true
    oidc_subjects = ["repo:Nero-Study-Hat/Personal_Website:ref:refs/heads/mvp"]
    oidc_audiences = ["sts.amazonaws.com"]

    trust_policy_permissions = {
        TrustUsersToAssume = {
            actions = [
                "sts:AssumeRole",
                "sts:TagSession",
            ]
            // root implies trust for all users in its account
            // auth responsability falls on AssumeRole permissions
            principals = [{
                type = "AWS"
                identifiers = [
                    "arn:aws:iam::${var.account_id}:root",
                ]
            }]
            // if external accounts were also a factor
            # condition = [{
            #     test     = "StringEquals"
            #     variable = "sts:ExternalId"
            #     values   = ["some-secret-id"]
            # }]
        }
    }

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
        sid = "DevPersonalWebsiteTerraform"

        actions = [
            "ec2:*",
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
    // need StateBackendAccess here declared for user permissions
    // because assume_role is not working with backend config
    statement {
        sid = "StateBackendAccess"
        // copied IAMFullAccess managed policy
        actions = [
                "s3:CreateBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:GetBucketLocation"
        ]
        resources = [
            "arn:aws:s3:::terraform-state-backend-0iw5ulc1",
            "arn:aws:s3:::terraform-state-backend-0iw5ulc1/*"
        ]
    }
    statement {
        sid = "AllowAmiDiscovery"
        actions = [
            "ec2:DescribeImages",
            "ec2:DescribeImageAttribute"
        ]
        resources = ["*"]
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