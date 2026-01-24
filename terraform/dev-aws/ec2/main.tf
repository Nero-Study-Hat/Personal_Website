resource "aws_instance" "web" {
  ami                    = var.amiID # Reference the AMI ID from the variable defined in variables.tf
  instance_type          = "t2.micro"
  key_name               = "terraform-vpc-ssh-key" #REPLACE WITH YOUR SSH KEY NAME
  subnet_id              = aws_subnet.Terraform_VPC-pub-1.id              # Reference the public subnet created in VPC.tf
  vpc_security_group_ids = [aws_security_group.terraform-ec2-setup-sg.id] # Reference the security group created in SecurityGroup.tf
  availability_zone      = var.zone                                      # Specify the availability zone


  tags = {
    Name    = "web"
    Project = "terraform-ec2-web-s3"
  }
  connection {
    type        = "ssh"                         # Use SSH for connection
    user        = var.webuser                   # Username for SSH connection, defined in variables.tf
    private_key = file("terraform-vpc-ssh-key") # REPLACE WITH YOUR SSH PRIVATE KEY FILE PATH
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "web.sh"      # Path to the shell script to be executed on the instance
    destination = "/tmp/web.sh" # Destination path on the instance
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh", # Ensure the script is executable
      "sudo /tmp/web.sh"      # Execute the script with sudo privileges
    ]
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}

resource "aws_ec2_instance_state" "web-state" {
  instance_id = aws_instance.web.id
  state       = "running" # Ensure the instance is in a running state
}

output "WebPublicIP" {
  description = "Public IP of Ubuntu instance"
  value       = aws_instance.web.public_ip # Output the public IP of the web instance
}
output "WebPrivateIP" {
  description = "Private IP of Ubuntu instance"
  value       = aws_instance.web.private_ip # Output the Private IP of the web instance
}