variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-02af70169146bbdd3" # Replace with your desired default AMI ID
}
variable "key_pair" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t3.micro" # Free tier eligible instance type
}

variable "instance_type_app" {
  description = "The instance type to use for the application server"
  type        = string
  default     = "t3.micro" # Free tier eligible instance type
}


variable "instance_type_monitoring" {
  description = "The instance type to use for the monitoring server"
  type        = string
  default     = "t3.micro" # Free tier eligible instance type
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
  default     = "eu-north-1a" # Use a specific availability zone
}


variable "app_port" {
  description = "The port on which the Laravel app will run"
  type        = number
  default     = 5001
}
