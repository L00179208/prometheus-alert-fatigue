variable "instance_type_app" {
  type        = string
  description = "Instance type for the application server"
}

variable "instance_type_monitoring" {
  type        = string
  description = "Instance type for the monitoring server"
}

variable "key_pair" {
  type        = string
  description = "Name of the key pair to use for SSH access"
}

variable "app_port" {
  type        = number
  description = "Port number for the application"
}

variable "ami" {
  type        = string
  description = "AMI ID to use for the EC2 instances"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone to deploy the resources"
}
variable "mysql_root_password" {
  description = "The root password for MySQL."
  type        = string
}

variable "mysql_database" {
  description = "The name of the MySQL database to create."
  type        = string
}

variable "mysql_user" {
  description = "The MySQL user to create."
  type        = string
}

variable "mysql_password" {
  description = "The password for the MySQL user."
  type        = string
}
