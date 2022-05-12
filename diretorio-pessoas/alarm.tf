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

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "Employee App CPU Util"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "Monitors ec2 cpu utilization by Employee Directory App."
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.user_updates.arn]
  ok_actions    = [aws_sns_topic.user_updates.arn]
  count         = var.instance["count"] != 0 ? 1 : 0

  dimensions = {
    InstanceId = aws_instance.web-server.0.id
  }

  tags = {
    Name               = "alrm-Directory-app-CPU-util"
    Environment        = var.domain
    "Application Role" = var.role
    Owner              = var.owner
    Customer           = var.customer
    Confidentiality    = var.confidentiality
  }
}