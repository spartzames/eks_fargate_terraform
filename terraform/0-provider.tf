provider "aws" {
  region = "ap-southeast-2"
}

variable "cluster_name" {
  default = "demo"
}

variable "cluster_version" {
  default = "1.22"
}

variable "cluster_service_ipv4_cidr" {
  type = string
}

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}