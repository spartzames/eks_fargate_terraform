provider "aws" {
  region = "ap-southeast-2"
}

variable "cluster_name" {
  default = "cluster-kthong"
}

variable "cluster_version" {
  default = "1.22"
}

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}