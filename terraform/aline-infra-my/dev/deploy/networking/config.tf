terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0" //review why version
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket = "aline-terraform-my"
    key = "networking.tfstate"
    region = "us-west-1"
  }
}