output "sns_topic_arn" {
  description = "SNS Topic ARN"
  value       = aws_sns_topic.alerts.arn
}

output "alarm_name" {
  description = "CloudWatch Alarm Name"
  value       = aws_cloudwatch_metric_alarm.high_memory.alarm_name
}

