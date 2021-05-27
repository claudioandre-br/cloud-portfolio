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

output "_040-web_server_count" {
  description = "Number of web servers provisioned"
  value       = length(aws_instance.worker)
}

output "_050-ip_addresses" {
  value = "${aws_instance.worker.*.public_ip}"
  description = "The IP address(es) of the instance(s)."
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

/* # NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
} */

# AZs
output "_060-AZs" {
  description = "List of availability zones"
  value       = module.vpc.azs
}