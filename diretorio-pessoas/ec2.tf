######################################################################
# Copyright (c) 2021 Claudio André <claudioandre.br at gmail.com>
#
# This program comes with ABSOLUTELY NO WARRANTY; express or implied.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, as expressed in version 2, seen at
# http://www.gnu.org/licenses/gpl-2.0.html
######################################################################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Images owned by Canonical
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"] # Images owned by Canonical
}

resource "aws_instance" "worker" {
  ami                    = data.aws_ami.amazon-linux-2.id
  subnet_id              = module.vpc.public_subnets.0
  key_name               = aws_key_pair.deploy.key_name
  instance_type          = var.instance["instance_type"]
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  count                  = "${var.spot != "yes" ? var.instance["count"] : 0}"
  iam_instance_profile   = "S3DynamoDBFullAccessRole"

  associate_public_ip_address = true

  credit_specification {
    cpu_credits = "standard"
  }

  # The connection uses the local SSH agent for authentication.
  connection {
    user        = "ec2-user"
    type        = "ssh"
    host        = self.public_ip
    private_key = local.private_key_content
  }

  # If you want to check if everything is Ok.
  provisioner "remote-exec" {
    inline = [
      "cd ~",
      "ls -lah"
    ]
  }

  # Security group rule must be created before this IP address could
  # actually be used, otherwise the services will be unreachable.
  depends_on = [module.vpc.public_subnets, aws_security_group.webserver-sg]

  user_data = "${file("start-up.sh")}"

  tags = {
    Name = "employee-directory-app${count.index + 1}-instance"
    Environment = var.domain
    "Application Role" = var.role
    Owner = var.owner
    Customer = var.customer
    Confidentiality = var.confidentiality
  }
}

resource "aws_key_pair" "deploy" {
  key_name   = "deploy-key"
  public_key = local.public_key_content
}

# You can also add your key here.
/*
resource "aws_key_pair" "deploy" {
  key_name   = "deploy-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
*/