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

# Create terraform workspaces (to choose accounts/regions to use). ###
# For example, to use a different IAM account or region, use the 'testing' workspace.
# $ terraform workspace new    testing
# $ terraform workspace select testing
# $ terraform workspace list

# TODO ###############################################################
# Set your AWS profile file AND/OR regions AND/OR the label.
variable "profile_list" {
  description = "Your section inside the `~/.aws/credentials` profile file."
  type = map(string)
  default = {
    default = "rh"
    testing = "rh-testing"
    production = "rh-production"
  }
}

variable "regions_list" {
  description = "AWS region to launch servers."
  type = map(string)
  default = {
    default = "us-east-1"
    testing = "us-east-1"
    production = "us-west-1"
  }
}

variable "environment_list" {
  description = "A label users might like to see."
  type = map(string)
  default = {
    default = "default"
    testing = "DEV"
    production = "PROD"
  }
}
# ####################################################################

# TODO ###############################################################
# Change SSH information, use your own keys or create a new one.
# Or run `$ ssh-keygen -t rsa -f workerKey`
variable "private_key" {
  default = "./workerKey"
  sensitive = true
}

variable "public_key" {
  default = "./workerKey.pub"
}

locals {
  public_key_content = "${file("${var.public_key}")}"
}

locals {
  private_key_content = "${file("${var.private_key}")}"
  sensitive = true
}
# ####################################################################

# TODO ###############################################################
# Pick up your EC2 instances environment.
variable instance {
  type = object({instance_type = string, count = number})
  default = {
    instance_type = "t2.micro", count = 0
  }
}
# ####################################################################

# TODO ###############################################################
# Set your Spot preferences.
variable "spot" {
  type = string
  description = "Use Spot instances? (yes or no)"
  default = ""

  validation {
    condition = (
      ((var.spot) == "" || (var.spot) == "yes" || (var.spot) == "no")
    )
    error_message = "The spot flag must be 'yes' or 'no'."
  }
}
variable "spot_price" {
  type = number
  description = "Use Spot instances?"
  default = 0.0116

  validation {
    condition = (
      (var.spot_price) > 0
    )
    error_message = "The spot price must be greater than zero."
  }
}
# ####################################################################

# TODO ###############################################################
# Set your Spot preferences.
variable admin_email {
  type = string
  default = "seuemail@provedor.com"
}
# ####################################################################

# Tags ###############################################################
variable domain {
  type = string
  default = "HR"
}

variable role {
  type = string
  default = "AWS employee directory example"
}
variable owner {
  type = string
  default = "User name"
}

variable customer {
  type = string
  default = "Customer or Project Name"
}

variable confidentiality {
  type = string
  default = "Default"
}