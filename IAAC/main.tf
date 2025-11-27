terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = ">= 4.0"
}
}

}


provider "aws" {
region = var.aws_region
}


data "aws_ami" "amazon_linux_2" {
most_recent = true
owners = ["amazon"]


filter {
name = "name"
values = ["amzn2-ami-hvm-*-x86_64-gp2"]
}
}


resource "aws_security_group" "ssh_sg" {
name = "deliverable13-ssh-sg"
description = "Allow SSH inbound"


ingress {
description = "SSH from allowed CIDR"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.allowed_ssh_cidr]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}


tags = var.common_tags
}



resource "aws_instance" "web" {
ami = data.aws_ami.amazon_linux_2.id
instance_type = var.instance_type
vpc_security_group_ids = [aws_security_group.ssh_sg.id]

key_name = (var.key_name != "" ? var.key_name : null)
tags = merge(var.common_tags, { "Name" = "w7p13-ec2" })


user_data = <<-EOF
#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx1
systemctl enable nginx
systemctl start nginx
echo "<h1>Deployed with Terraform </h1>" > /usr/share/nginx/html/index.html
EOF
}



resource "aws_s3_bucket" "app_bucket" {
bucket = var.s3_bucket_name
tags = merge(var.common_tags, { "Name" = "w7p13-bucket" })
force_destroy = var.s3_force_destroy
}

resource "aws_s3_bucket_public_access_block" "app_bucket" {
bucket = aws_s3_bucket.app_bucket.id
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
}



resource "aws_s3_bucket_versioning" "bucket_versioning" {
bucket = aws_s3_bucket.app_bucket.id


versioning_configuration {
status = var.s3_versioning ? "Enabled" : "Suspended"
}
}


resource "aws_s3_object" "welcome" {
bucket = aws_s3_bucket.app_bucket.id
key = "welcome.txt"
content = "This bucket was created by Terraform."
}