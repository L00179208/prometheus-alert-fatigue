resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = var.instance_type_app
  subnet_id              = aws_subnet.public_az1.id # Update to use the correct subnet
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "MonolithicAppServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker python3 git

              # Start Docker service
              service docker start
              usermod -aG docker ec2-user
              EOF
}

resource "aws_instance" "monitoring_server" {
  ami                    = var.ami
  instance_type          = var.instance_type_monitoring
  subnet_id              = aws_subnet.public_az1.id # Update to use the correct subnet
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "PrometheusServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker python3 git

              # Start Docker service
              service docker start
              usermod -aG docker ec2-user
              EOF
}
