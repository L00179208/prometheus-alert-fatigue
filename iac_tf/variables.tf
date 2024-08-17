variable "ami" {
  description = "The AMI ID to use for the EC2 instances"
  type        = string
  default     = "ami-02af70169146bbdd3" # Replace with your preferred default AMI ID
}

variable "instance_type_app" {
  description = "The instance type for the application server"
  type        = string
  default     = "t3.micro"
}

variable "instance_type_monitoring" {
  description = "The instance type for the monitoring server"
  type        = string
  default     = "t3.micro"
}
