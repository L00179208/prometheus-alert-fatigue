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

              # Create a Docker network
              docker network create ${var.network_name}

              # Run the MySQL container
              docker run -d --name db --network ${var.network_name} \
                -e MYSQL_ROOT_PASSWORD=${var.mysql_root_password} \
                -e MYSQL_DATABASE=${var.mysql_database} \
                -e MYSQL_USER=${var.mysql_user} \
                -e MYSQL_PASSWORD=${var.mysql_password} \
                -p 3306:3306 mysql:8.0

              # Run the application container
              docker run -d --name app --network ${var.network_name} \
                -p ${var.app_port}:${var.app_port} \
                -e DATABASE_URL=mysql+pymysql://root:${var.mysql_root_password}@db:3306/${var.mysql_database} \
                -e FLASK_ENV=production \
                -e SECRET_KEY=your_secret_key \
                ${var.dockerhub_image}
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
