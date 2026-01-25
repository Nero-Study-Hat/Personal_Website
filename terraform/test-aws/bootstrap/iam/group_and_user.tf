module "iam_group-iam-controllers" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-group"
    version = "6.4.0"

    name = "IAM-controllers-group"

    users = [
        module.iam_user-neostudyhat.name
    ]

    # these are defaults but I want them here explicitly for awareness
    enable_self_management_permissions = true
    enable_mfa_enforcement             = true
    create_policy                      = true

    policies = {
        IAMFullAccess               = "arn:aws:iam::aws:policy/IAMFullAccess",
        # Console & Intergration Permissions Needed Alongside IAMFullAccess
        AWSOrganizationsFullAccess  = "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess",
        IAMAccessAnalyzerFullAccess = "arn:aws:iam::aws:policy/IAMAccessAnalyzerFullAccess"

    }

    tags = {
        Terraform   = "true"
    }
}

module "iam_group-developers" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-group"
    version = "6.4.0"

    name = "developers-group"

    users = [
        module.iam_user-neostudyhat.name
    ]

    # these are defaults but I want them here explicitly for awareness
    enable_self_management_permissions = true
    enable_mfa_enforcement             = true
    create_policy                      = true

    permissions = {
        AssumeRole = {
            actions   = ["sts:AssumeRole"]
            resources = [
                module.iam_role-dev-personal-website.arn
            ]
        }
    }

    tags = {
        Terraform   = "true"
    }
}

module "iam_user-neostudyhat" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-user"
    version = "6.4.0"

    name = "neostudyhat"

    create_login_profile    = true
    create_access_key       = false
    force_destroy           = true

    # user and/or group(s) and/or policies / other config
    # can be updated after passwd change and MFA setup
    # without breaking initial manual passwd change and MFA setup  
    password_length         = 24
    password_reset_required = true

    tags = {
        Terraform   = "true"
    }
}