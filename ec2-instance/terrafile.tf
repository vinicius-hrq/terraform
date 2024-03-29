terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "vinicius-hrq-terraform"
    key     = "terraform-test.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "web" {
  source        = "git@github.com:vinicius-hrq/terraform-module?ref=v0.2"
  name          = "web"
  enable_sg     = true
  ingress_ports = [80, 443]
}

output "dns" {
  value = module.web.dns_name
}