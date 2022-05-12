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

# You can create varios envirnoments (e.g., PROD, DEV, TEST)
output "_010-current_environment" {
  value = local.run_env
}

# VPC
output "_020-vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "_030-vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Subnets
output "_035-private_subnets" {
  description = "List of IDs of private subnets"
  value       = join(", ", module.vpc.private_subnets)
}

output "_036-public_subnets" {
  description = "List of IDs of public subnets"
  value       = join(", ", module.vpc.public_subnets)
}

output "_040-webServer_count" {
  description = "Number of web servers provisioned"
  value       = length(aws_instance.web-server)
}

output "_050-webServer_ip_addresses" {
  description = "The IP address(es) of the instance(s)."
  value       = join(", ", "${aws_instance.web-server.*.public_ip}")
}

# AZs
output "_060-AZs" {
  description = "List of availability zones"
  value       = module.vpc.azs
}

output "_070-DNS_name" {
  description = "Application DNS (ALB DNS name)"
  value       = aws_lb.app-elb.dns_name
}

/* # NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
} */