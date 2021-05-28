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

resource "aws_autoscaling_group" "app-asg" {
  name                      = "app-target-group"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = module.vpc.public_subnets

  target_group_arns = [aws_lb_target_group.front_end.arn]

  launch_template {
    id      = aws_launch_template.web-server.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "asg-employee-directory"
    propagate_at_launch = false
  }
  tag {
    key = "Name"
    value = "i-employee-directory"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = var.domain
    propagate_at_launch = true
  }
  tag {
    key = "Application Role"
    value = var.role
    propagate_at_launch = true
  }
  tag {
    key = "Owner"
    value = var.owner
    propagate_at_launch = true
  }
  tag {
    key = "Customer"
    value = var.customer
    propagate_at_launch = true
  }
  tag {
    key = "Confidentiality"
    value = var.confidentiality
    propagate_at_launch = true
  }
}