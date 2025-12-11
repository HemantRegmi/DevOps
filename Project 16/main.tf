terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "example" {
  bucket_prefix = "jenkins-terraform-demo-"

  tags = {
    Name        = "Jenkins Terraform Demo"
    Environment = "Dev"
  }
}
