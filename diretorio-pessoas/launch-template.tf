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

resource "aws_launch_template" "web-server" {
  name           = "template-Directory-app"
  description    = "A web server for the employee directory application."
  image_id       = data.aws_ami.amazon-linux-2.id
  instance_type  = var.instance["instance_type"]
  key_name       = aws_key_pair.deploy.key_name

  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  user_data              = "${filebase64("start-up.sh")}"

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }

  # Security group rule must be created before this IP address could
  # actually be used, otherwise the services will be unreachable.
  depends_on = [aws_security_group.webserver-sg]


  tags = {
    Name = "lt-employee-directory-app"
    Environment = var.domain
    "Application Role" = var.role
    Owner = var.owner
    Customer = var.customer
    Confidentiality = var.confidentiality
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "i-employee-directory-app"
      Environment = var.domain
      "Application Role" = var.role
      Owner = var.owner
      Customer = var.customer
      Confidentiality = var.confidentiality
    }
  }
}