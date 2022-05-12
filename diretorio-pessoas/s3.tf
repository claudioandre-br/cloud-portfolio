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

data "aws_caller_identity" "current" {}

variable "bucket-name" {
  type        = string
  description = "The app bucket name; MUST be unique."
  default     = "employee-photo-bucket-cl" # TODO bucked-id.
}

variable "logs-name" {
  type        = string
  description = "The logs bucket name; MUST be unique."
  default     = "logs-apps-internal" # TODO bucked-id.
}

resource "aws_s3_bucket_public_access_block" "block-public" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "bucket" {
  bucket     = var.bucket-name
  depends_on = [aws_iam_role.role]

  # Terraform will delete all of the objects in the bucket for you. ## BE CAREFUL ##
  force_destroy = true

  # Terraform's "jsonencode" converts to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3ReadAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/EC2S3DynamoDBFullAccessRole"
        },
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::${var.bucket-name}",
          "arn:aws:s3:::${var.bucket-name}/*"
        ]
      }
    ]
  })

  tags = {
    Name               = "s3-employee-directory-app"
    Environment        = var.domain
    "Application Role" = var.role
    Owner              = var.owner
    Customer           = var.customer
    Confidentiality    = var.confidentiality
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = var.logs-name

  # Terraform will delete all of the objects in the bucket for you. ## BE CAREFUL ##
  force_destroy = true

  # Terraform's "jsonencode" converts to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AWSConsoleStmt-1622223213824",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::127311923021:root"
        },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${var.logs-name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      },
      {
        "Sid" : "AWSLogDeliveryWrite",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${var.logs-name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        "Sid" : "AWSLogDeliveryAclCheck",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "arn:aws:s3:::${var.logs-name}"
      }
    ]
  })

  tags = {
    Name               = "s3-logs"
    Environment        = var.domain
    "Application Role" = var.role
    Owner              = var.owner
    Customer           = var.customer
    Confidentiality    = var.confidentiality
  }
}