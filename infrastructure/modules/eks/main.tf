# --- MONITORING AND ALERTS ---

# 1. Create an SNS Topic for sending notifications
resource "aws_sns_topic" "eks_alerts" {
  name = "${var.project_name}-eks-alerts-topic"
}

# 2. Create a CloudWatch Alarm for high CPU on the worker nodes
resource "aws_cloudwatch_metric_alarm" "node_group_high_cpu" {
  alarm_name          = "${var.project_name}-node-group-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = "80"  # 80% CPU
  alarm_description   = "This alarm fires when the EKS node group average CPU utilization exceeds 80%."

  dimensions = {
    # This targets the specific Auto Scaling group created by our EKS node group
    "AutoScalingGroupName" = aws_eks_node_group.main.resources[0].autoscaling_groups[0].name
  }

  # Send a notification to our SNS topic when the alarm state is reached
  alarm_actions = [aws_sns_topic.eks_alerts.arn]
  ok_actions    = [aws_sns_topic.eks_alerts.arn]
}