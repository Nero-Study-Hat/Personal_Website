module "tailscale" {
    source   = "tailscale/tailscale/cloudinit"
    version  = "0.0.9"

    auth_key              = var.tailscale_auth_key # a tag set to be ephemeral
    tailscaled_flag_state = "mem:"                 # This makes it use no state storage
    
    enable_ssh     = true
    hostname       = "aws-tailscale-server"
}

# Combine Tailscale and custom Cloud-Init using cloudinit_config data source
data "cloudinit_config" "combined" {
    gzip          = false
    base64_encode = true

    # Tailscale configuration (decode first since module provides base64)
    part {
        content_type = "text/cloud-config"
        content      = base64decode(module.tailscale.rendered)
        merge_type   = "list(append)+dict(recurse_array)+str()"
    }

    # Custom configuration
    part {
        content_type = "text/cloud-config"
        content      = file("${path.module}/../../../../cloud_init/aws_conf.yml")
        merge_type   = "list(append)+dict(recurse_array)+str()"
    }
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
    ami             = data.aws_ami.ubuntu.id
    instance_type   = "t3.micro"
    subnet_id       = var.private_subnet_id
    # security_groups = [var.security_group_id]
    vpc_security_group_ids = [var.security_group_id]

    ebs_optimized = true

    user_data_base64            = data.cloudinit_config.combined.rendered
    associate_public_ip_address = false

    metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"
    }

    tags = {
        Name    = "user-data-tailscale-ubuntu"
        Project = var.project
    }
}