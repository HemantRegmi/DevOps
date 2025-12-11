variable "aws_region" {
description = "AWS region to deploy into"
type = string
default = "us-east-1"
}


variable "instance_type" {
description = "EC2 instance type"
type = string
default = "t3.micro"
}


variable "key_name" {
description = "Existing AWS key pair name to attach to the instance (required for SSH). Leave blank to not attach."
type = string
default = ""
}


variable "allowed_ssh_cidr" {
description = "CIDR that is allowed to SSH to the instance (for example your IP/32)."
type = string
default = "0.0.0.0/0"
}


variable "s3_bucket_name" {
description = "Name of the S3 bucket to create. Must be globally unique."
type = string
}


variable "s3_force_destroy" {
description = "If true, the S3 bucket will be forcibly destroyed even if it contains objects"
type = bool
default = false
}


variable "s3_versioning" {
description = "Enable versioning on the S3 bucket"
type = bool
default = false
}


variable "tfstate_bucket" {
description = "(Optional) S3 bucket name for remote Terraform state backend"
type = string
default = ""
}


variable "tfstate_lock_table" {
description = "(Optional) DynamoDB table name for state locking"
type = string
default = ""
}


variable "common_tags" {
description = "Common tags applied to resources"
type = map(string)
default = {
Owner = "Deliverable13"
Env = "dev"
}
}