output "instance_id" {
description = "The EC2 instance id"
value = aws_instance.web.id
}


output "instance_public_ip" {
description = "Public IP of the EC2 instance"
value = aws_instance.web.public_ip
}


output "s3_bucket_id" {
description = "Name of the S3 bucket created"
value = aws_s3_bucket.app_bucket.id
}


output "s3_bucket_arn" {
description = "ARN of the S3 bucket"
value = aws_s3_bucket.app_bucket.arn
}