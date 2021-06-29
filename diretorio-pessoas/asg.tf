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
  name                      = "asg-Directory-app"
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

resource "aws_autoscaling_notification" "scaling-notification" {
  group_names = [aws_autoscaling_group.app-asg.name]
  topic_arn = aws_sns_topic.user_updates.arn

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
}

# Scale-out policy
resource "aws_autoscaling_policy" "cpu-policy-scaleup" {
  name                   = "cpu-policy-scaleup"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
}

# Scale-in policy
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
  name                   = "cpu-policy-scaledown"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
}

# Scale-out alarm (increase)
resource "aws_cloudwatch_metric_alarm" "cpu-scaleup" {
  alarm_name          = "alrm-scale-out"
  alarm_description   = "Alarm that scals-out the Directory app."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "65"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.app-asg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.cpu-policy-scaleup.arn]
}

# Scale-in alarm (decrease)
resource "aws_cloudwatch_metric_alarm" "cpu-scaledown" {
  alarm_name          = "alrm-scale-in"
  alarm_description   = "Alarm that scales-in the Directory app."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "58.5"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.app-asg.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.cpu-policy-scaledown.arn]
}