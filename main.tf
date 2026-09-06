terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "myec2_1" {
  ami           = "ami-081b0a6eac00b4f53"
  instance_type = "t3.micro"
  tags = {
    "name" = "myinstance"
  }

}