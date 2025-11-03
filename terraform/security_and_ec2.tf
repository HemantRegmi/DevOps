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

  # Example: allow SSH from your office/Bastion (commented out). Typically you'll use SSM instead.
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["YOUR_OFFICE_IP/32"]
  # }

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
  # aws_subnet.private is a map (created with for_each). Use values(...) and index into the list.
  subnet_id              = values(aws_subnet.private)[0].id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # Use key_name only if you need it (instance has no public IP, so SSH via private network or bastion)
  key_name = var.private_key_name != "" ? var.private_key_name : null

  # simple userdata to install SSM Agent (amazon linux2 already has SSM agent)
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              EOF

  tags = merge(var.tags, { Name = "project8-private-ec2" })
}
