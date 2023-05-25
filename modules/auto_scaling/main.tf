#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#   use data source to get all avalablility zones in region
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available_zones" {}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  fetching AMI ID
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["amazon"]
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create launch configuration
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_launch_configuration" "custom-launch-config" {
  name            = "${var.project_name}-config"
  image_id        = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [var.public_ec2_security_group]
  user_data       = data.template_file.user_data.rendered
  lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create auto scaling group
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_autoscaling_group" "custom-autoscaling-group" {
  name                      = "${var.project_name}-auto-scaling-group"
  vpc_zone_identifier       = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  launch_configuration      = aws_launch_configuration.custom-launch-config.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.min_size
  health_check_grace_period = 100
  health_check_type         = "EC2"
  force_delete              = true
  // target_group_arns    = [var.target_group_arn]
  termination_policies = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create auto scaling policy (scale out)
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_autoscaling_schedule" "custom-autoscaling-policy-scale-out" {
  scheduled_action_name = "${var.project_name}-auto-scaling-policy-scale-out"
  min_size              = 4
  max_size              = 10
  desired_capacity      = 4
  time_zone             = "Europe/Helsinki"
  //start_time            = "2023-05-25T01:15:00Z"
  //end_time              = "2023-05-25T01:20:00Z"
  recurrence             = "00 12 * * 1-5"
  autoscaling_group_name = aws_autoscaling_group.custom-autoscaling-group.name
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create auto scaling policy (scale in i.e. descaling)
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_autoscaling_schedule" "custom-autoscaling-policy-scale-in" {
  scheduled_action_name = "${var.project_name}-auto-scaling-policy-scale-in"
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.min_size
  time_zone             = "Europe/Helsinki"
  //start_time            = "2023-05-25T01:20:00Z"
  //end_time              = "2023-05-25T01:30:00Z"
  recurrence             = "00 13 * * 1-5"
  autoscaling_group_name = aws_autoscaling_group.custom-autoscaling-group.name
}

/*
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create cloudwatch alarm (scale out)
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "custom-cloudwatch-alarm-scale-out" {
  alarm_name          = "${var.project_name}-scale-out- alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.custom-autoscaling-group.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.custom-autoscaling-policy-scale-out.arn]
}
*/


/*
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create cloudwatch alarm (scale in i.e. cloudwatch for descaling)
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "custom-cloudwatch-alarm-scale-in" {
  alarm_name          = "${var.project_name}-scale-in-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.custom-autoscaling-group.name
  }
  actions_enabled   = true
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.custom-autoscaling-policy-scale-in.arn]
}
*/
