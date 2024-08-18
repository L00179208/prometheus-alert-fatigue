variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type_app" {
  description = "Instance type for the application server"
  type        = string
}

variable "instance_type_monitoring" {
  description = "Instance type for the monitoring server"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID for the instances"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for the application server"
  type        = string
}

variable "monitoring_sg_id" {
  description = "Security group ID for the monitoring server"
  type        = string
}

variable "key_pair" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "app_port" {
  description = "Port on which the application will run"
  type        = number
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
