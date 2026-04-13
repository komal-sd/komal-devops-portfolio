terraform {
  required_version = ">=1.5.0"

  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "task-management-tfstate-komal-1774522825"
    key = "komal-portfolio/terraform.tfstate"
    region = "ap-south-1"
  } 
}
provider "aws" {
  region = var.aws_region
}
