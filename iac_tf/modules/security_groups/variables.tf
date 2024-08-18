variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Port on which the application will run"
  type        = number
  default     = 5000
}
