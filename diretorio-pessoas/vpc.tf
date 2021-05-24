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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "app-vpc"
  cidr = "10.1.0.0/16"

  azs              = ["${local.region}a", "${local.region}b"]
  private_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets   = ["10.1.11.0/24", "10.1.12.0/24"]
  database_subnets = ["10.1.21.0/24", "10.1.22.0/24"]

  create_igw = true
  map_public_ip_on_launch = false

  create_database_subnet_route_table    = true

  tags = {
    Environment = var.domain
    "Application Role" = var.role
    Owner = var.owner
    Customer = var.customer
    Confidentiality = var.confidentiality
  }

  vpc_tags = {
    Name = "app-vpc"
  }

  igw_tags = {
    Name = "app-igw"
  }

  public_subnet_tags = {
    Name = "Public Subnet"
  }

  private_subnet_tags = {
    Name = "Private Subnet"
  }

  database_subnet_tags = {
    Name = "app-DB-Subnet"
  }

  private_route_table_tags = {
    Name = "app-routetable-private"
  }

  public_route_table_tags = {
    Name = "app-routetable-public"
  }

  database_route_table_tags = {
    Name = "app-routetable-DB"
  }
}