provider "aws" {
  region = var.region.region
  # access_key = ""
  # secret_key = ""
}

#cloudfront acm 인증서 발급 지역
provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

resource "aws_vpc" "vpc" {    
  cidr_block = var.cidr.vpc
  enable_dns_hostnames = true 
  enable_dns_support = true
  tags = {
    "Name" = "${format("%s-vpc", var.name)}"
  }
}