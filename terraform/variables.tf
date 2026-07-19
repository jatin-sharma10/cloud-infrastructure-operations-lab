variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
  default     = "cloud-ops-lab"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "instance_id" {
  description = "EC2 instance ID monitored by CloudWatch"
  type        = string
}

variable "alarm_email" {
  description = "Email address that receives infrastructure alerts"
  type        = string
  sensitive   = true
}
