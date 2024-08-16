resource "aws_instance" "app_server" {
  ami                    = var.ami
  instance_type          = var.instance_type_app
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = var.key_pair # Use the new key pair


  associate_public_ip_address = true # Explicitly associate a public IP address

  tags = {
    Name = "MonolothicAppServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker

              # Start Docker service
              service docker start
              usermod -aG docker ec2-user

              # Pull the Docker image from Docker Hub
              docker pull l00179208/promethuse-alert-manager:latest

              # Run the Docker container on the specified port
              docker run -d -p ${var.app_port}:${var.app_port} l00179208/promethuse-alert-manager:latest
              EOF
}

resource "aws_instance" "monitoring_server" {
  ami                    = var.ami
  instance_type          = var.instance_type_monitoring
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = var.key_pair # Use the new key pair


  associate_public_ip_address = true # Explicitly associate a public IP address

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

              # Pull and run Prometheus container
              docker run -d -p 9090:9090 prom/prometheus
              EOF
}
