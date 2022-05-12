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

# Access Security Group Rule #########################################
variable "web_ingress_data" {
  description = "The security groups inbound rules."
  type        = map(object({ port = string, description = string, cidr_blocks = list(string) }))
  default = {
    80 = { port = "80", description = "Inbound HTTP rule.", cidr_blocks = ["0.0.0.0/0"] }
  }
}

variable "web_egress_data" {
  description = "The security groups outbound rules."
  type        = map(object({ port = string, description = string, cidr_blocks = list(string), ipv6_cidr_blocks = list(string) }))
  default = {
    443 = { port = "443", description = "Outbound HTTPS rule.", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
  }
}

variable "internal_ingress_data" {
  description = "The security groups inbound rules."
  type        = map(object({ port = string, description = string, cidr_blocks = list(string) }))
  default = {
    80 = { port = "80", description = "From ALB inbound HTTP rule.", cidr_blocks = ["Not used"] }
  }
}

variable "internal_egress_data" {
  description = "The security groups inbound rules."
  type        = map(object({ port = string, description = string, cidr_blocks = list(string) }))
  default = {
    80 = { port = "80", description = "ALB outbound HTTP rule.", cidr_blocks = ["Not used"] }
  }
}

resource "aws_security_group_rule" "webserver-in" {
  security_group_id = aws_security_group.webserver-sg.id

  type                     = "ingress"
  description              = var.internal_ingress_data[80].description
  from_port                = var.internal_ingress_data[80].port
  to_port                  = var.internal_ingress_data[80].port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb-sg.id
}

resource "aws_security_group_rule" "webserver-out" {
  security_group_id = aws_security_group.webserver-sg.id

  type             = "egress"
  description      = var.web_egress_data[443].description
  from_port        = var.web_egress_data[443].port
  to_port          = var.web_egress_data[443].port
  protocol         = "tcp"
  cidr_blocks      = var.web_egress_data[443].cidr_blocks
  ipv6_cidr_blocks = var.web_egress_data[443].ipv6_cidr_blocks
}

resource "aws_security_group_rule" "alb-in" {
  security_group_id = aws_security_group.alb-sg.id

  type        = "ingress"
  description = var.web_ingress_data[80].description
  from_port   = var.web_ingress_data[80].port
  to_port     = var.web_ingress_data[80].port
  protocol    = "tcp"
  cidr_blocks = var.web_ingress_data[80].cidr_blocks
}

resource "aws_security_group_rule" "alb-out" {
  security_group_id = aws_security_group.alb-sg.id

  type                     = "egress"
  description              = var.internal_egress_data[80].description
  from_port                = var.internal_egress_data[80].port
  to_port                  = var.internal_egress_data[80].port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver-sg.id
}


resource "aws_security_group" "webserver-sg" {
  name        = "web-server-sg"
  description = "Enable HTTP access from ALB. Allow access to obtain software updates and to DynamoDB."
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name               = "sg-web-server"
    Environment        = var.domain
    "Application Role" = var.role
    Owner              = var.owner
    Customer           = var.customer
    Confidentiality    = var.confidentiality
  }
}

resource "aws_security_group" "alb-sg" {
  name        = "elastic-balancer-sg"
  description = "Enable HTTP access from Internet."
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name               = "sg-elastic-balancer"
    Environment        = var.domain
    "Application Role" = var.role
    Owner              = var.owner
    Customer           = var.customer
    Confidentiality    = var.confidentiality
  }
}