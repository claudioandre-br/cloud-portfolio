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

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "Instance-Dashboard"
  count = "${var.instance["count"] != 0 ? 1 : 0}"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "view":"timeSeries",
        "stacked":false,
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${aws_instance.web-server.0.id}"
          ]
        ],
        "region": "${local.region}",
        "title": "EC2 Instance CPU"
      }
    }
  ]
}
EOF

}

resource "aws_cloudwatch_dashboard" "asg-dashboard" {
  dashboard_name = "Directory-app"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "view":"timeSeries",
        "stacked":false,
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "AutoScalingGroupName",
            "${aws_autoscaling_group.app-asg.name}"
          ]
        ],
        "region": "${local.region}",
        "title": "Auto Scaling CPU Usage"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "Testing"
      }
    }
  ]
}
EOF

}