variable "cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS Service"
  type        = string
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
          region = "ap-south-1"
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
            [ "AWS/ECS", "RunningTaskCount", "ServiceName", var.service_name, "ClusterName", var.cluster_name ]
          ]
          period = 60
          stat   = "Maximum"
          region = "ap-south-1"
          title  = "Active Task Count"
        }
      },
      
    ]
  })
}