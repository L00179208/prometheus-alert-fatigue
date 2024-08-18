resource "aws_instance" "app_server" {
  ami                         = var.ami
  instance_type               = var.instance_type_app
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = var.key_pair
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Update the package list and install Docker
              sudo yum update -y
              sudo yum install -y docker

              # Start Docker service and enable it to start on boot
              sudo systemctl start docker
              sudo systemctl enable docker

              # Add the ec2-user to the Docker group so you can execute Docker commands without using sudo
              sudo usermod -aG docker ec2-user

              # Pull the Docker image from Docker Hub
              sudo docker pull l00179208/promethuse-alert-manager:latest

              # Run the Docker container with restart policy to ensure it starts on reboot
              sudo docker run -d --restart unless-stopped -p ${var.app_port}:${var.app_port} l00179208/promethuse-alert-manager:latest

              # Install MariaDB server
              sudo yum install -y mariadb-server

              # Start and enable MariaDB service
              sudo systemctl start mariadb
              sudo systemctl enable mariadb

              # Secure MariaDB installation and set up the database
              sudo mysql -e "CREATE DATABASE IF NOT EXISTS ${var.mysql_database};"
              sudo mysql -e "CREATE USER IF NOT EXISTS '${var.mysql_user}'@'localhost' IDENTIFIED BY '${var.mysql_password}';"
              sudo mysql -e "GRANT ALL PRIVILEGES ON ${var.mysql_database}.* TO '${var.mysql_user}'@'localhost';"
              sudo mysql -e "FLUSH PRIVILEGES;"

              EOF

  tags = {
    Name = "SnapUrlAppServer"
  }
}

resource "aws_instance" "monitoring_server" {
  ami                         = var.ami
  instance_type               = var.instance_type_monitoring
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.monitoring_sg_id]
  key_name                    = var.key_pair
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker

              # Start Docker service
              sudo systemctl start docker
              sudo systemctl enable docker

              # Add the ec2-user to the Docker group
              sudo usermod -aG docker ec2-user

              # Pull and run Prometheus container with restart policy
              sudo docker run -d --restart unless-stopped -p 9090:9090 prom/prometheus
              EOF

  tags = {
    Name = "MonitoringServer"
  }
}


output "app_server_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "monitoring_server_public_ip" {
  value = aws_instance.monitoring_server.public_ip
}
