variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The main CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "A list of Availability Zones to deploy subnets into."
  type        = list(string)
}