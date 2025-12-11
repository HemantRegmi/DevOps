# Security group for the private EC2 instance
resource "aws_security_group" "private_instance_sg" {
  name        = "project8-private-instance-sg"
  description = "Allow outbound internet via NAT and internal VPC access"
  vpc_id      = aws_vpc.this.id

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }

  tags = var.tags
}

# Get an Amazon Linux 2 AMI
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "private_ec2" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  subnet_id              = values(aws_subnet.private)[0].id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  key_name = var.private_key_name != "" ? var.private_key_name : null

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              EOF

  tags = merge(var.tags, { Name = "project8-private-ec2" })
}
