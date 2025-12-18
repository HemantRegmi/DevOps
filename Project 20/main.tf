variable "cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS Service"
  type        = string
}

variable "aws_region" {
  description = "AWS region for CloudWatch dashboard"
  type        = string
  default     = "ap-south-1"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_dashboard" "ecs_ec2_dashboard" {
  dashboard_name = "ECS-EC2-Health-${var.cluster_name}"

  dashboard_body = jsonencode({
    widgets = [
      
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name ],
            [ "AWS/ECS", "MemoryUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name ]
          ]
          period = 60
          stat   = "Average"
          region = var.aws_region
          title  = "ECS Service Resource Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ServiceName", var.service_name, "ClusterName", var.cluster_name, { stat = "SampleCount", label = "Running Tasks" } ],
            [ ".", "MemoryUtilization", ".", ".", ".", ".", { stat = "SampleCount", label = "Desired Tasks (approx)" } ]
          ]
          period = 60
          stat   = "Average"
          region = var.aws_region
          title  = "Active Task Count"
          yAxis = {
            left = {
              label = "Count"
            }
          }
        }
      },
      
    ]
  })
}