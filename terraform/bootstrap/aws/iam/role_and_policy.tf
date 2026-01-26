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
            // having this ensure if I forget one that is more easily found
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
        sid     = "AllowCreateWithCorrectProjectTag"
        effect  = "Allow"
        actions = [
            "ec2:CreateVpc",
            "ec2:CreateInternetGateway",
            "ec2:AttachInternetGateway",
            "ec2:CreateSubnet",
            "ec2:CreateNatGateway",
            "ec2:CreateRouteTable",
            "ec2:CreateRoute",
            "ec2:AssociateRouteTable",
            "ec2:AllocateAddress",
            "ec2:CreateVolume",
            "elasticloadbalancing:Create*",
            "dynamodb:CreateTable",
            "ec2:DisassociateAddress"
        ]
        resources = ["*"]
        condition {
            test     = "StringEquals"
            variable = "aws:RequestTag/Project"
            values = ["Personal-Website"]
        }
    }

    statement {
        sid       = "AllowCreateSecurityGroupWithTag"
        effect    = "Allow"
        actions   = ["ec2:CreateSecurityGroup"]
        resources = ["arn:aws:ec2:*:*:security-group/*"]
        // condition breaks
        # condition {
        #     test     = "StringEquals"
        #     variable = "aws:RequestTag/Project"
        #     values   = ["Personal-Website"]
        # }
    }

    statement {
        sid       = "AllowCreateSecurityGroupInVpc"
        effect    = "Allow"
        actions   = ["ec2:CreateSecurityGroup"]
        resources = ["arn:aws:ec2:*:*:vpc/*"]
    }

    statement {
        sid     = "AllowSecurityGroupRuleManagement"
        effect  = "Allow"
        actions = [
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RevokeSecurityGroupIngress"
        ]
        resources = ["arn:aws:ec2:*:*:security-group/*"]
        condition {
            test     = "StringEquals"
            variable = "aws:ResourceTag/Project"
            values   = ["Personal-Website"]
        }
    }

    statement {
        sid     = "AllowRunInstancesWithProjectTag"
        effect  = "Allow"
        actions = [
            "ec2:RunInstances"
        ]
        resources = [
            "arn:aws:ec2:*:*:instance/*",
            "arn:aws:ec2:*:*:volume/*"
        ]
        condition {
            test     = "StringEquals"
            variable = "aws:RequestTag/Project"
            values   = ["Personal-Website"]
        }
    }

    statement {
        sid     = "AllowRunInstancesOnSupportingResources"
        effect  = "Allow"
        actions = [
            "ec2:RunInstances"
        ]
        resources = [
            "arn:aws:ec2:*:*:subnet/*",
            "arn:aws:ec2:*:*:network-interface/*",
            "arn:aws:ec2:*:*:security-group/*",
            "arn:aws:ec2:*:*:key-pair/*",
            "arn:aws:ec2:*:*:image/*"
        ]
    }

    statement {
        sid     = "AllowRunInstancesOnVolumes"
        effect  = "Allow"
        actions = ["ec2:RunInstances"]
        resources = ["arn:aws:ec2:*:*:volume/*"]
    }

    statement {
        sid     = "AllowDescribeOperations"
        effect  = "Allow"
        actions = [
            // make res when created visible to terraform
            "ec2:Describe*",
            "elasticloadbalancing:Describe*",
            "dynamodb:Describe*",
            "dynamodb:List*"
        ]
        resources = ["*"]
    }

    // note: if no sec group added to an instance, one with
    // no tag will be attempted to be added and the terraform
    // apply will break, always use a minimal sg to prevent default issue
    statement {
        sid     = "DenyCreateWithoutProjectTag"
        effect  = "Deny"
        actions = [
            "ec2:CreateVpc",
            "ec2:AllocateAddress",
            "ec2:CreateVolume",
            "elasticloadbalancing:Create*",
            "dynamodb:CreateTable"
        ]
        resources = ["*"]
        condition {
            test     = "Null"
            variable = "aws:RequestTag/Project"
            values = ["true"]
        }
    }

    statement {
        sid     = "AllowOperateOnlyOnTaggedResources"
        effect  = "Allow"
        actions = [
            "ec2:*",
            "elasticloadbalancing:*",
            "dynamodb:*"
        ]
        resources = ["*"]
        condition {
            test     = "StringEquals"
            variable = "aws:ResourceTag/Project"
            values = ["Personal-Website"]
        }
    }

    statement {
        sid     = "AllowTaggingForProjectResources"
        effect  = "Allow"
        actions = [
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:RemoveTags",
            "dynamodb:TagResource",
            "dynamodb:UntagResource"
        ]
        resources = ["*"]
        condition {
            test     = "StringEquals"
            variable = "aws:RequestTag/Project"
            values = ["Personal-Website"]
        }
    }

    statement {
        sid     = "AllowTaggingForProjectResourcesByResourceTag"
        effect  = "Allow"
        actions = [
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:RemoveTags",
            "dynamodb:TagResource",
            "dynamodb:UntagResource"
        ]
        resources = ["*"]
        condition {
            test     = "StringEquals"
            variable = "aws:ResourceTag/Project"
            values = ["Personal-Website"]
        }
    }

    statement {
        sid     = "AllowTaggingDuringResourceCreation"
        effect  = "Allow"
        actions = ["ec2:CreateTags"]
        resources = [
            "arn:aws:ec2:*:*:volume/*",
            "arn:aws:ec2:*:*:instance/*",
            "arn:aws:ec2:*:*:network-interface/*"
        ]
        condition {
            test     = "StringEquals"
            variable = "ec2:CreateAction"
            values = ["RunInstances", "CreateVolume"]
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