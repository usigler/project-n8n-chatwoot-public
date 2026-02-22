terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    key = "0-acm/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# Variables
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "certificate_path" {
  description = "Path to the certificate file"
  type        = string
}

variable "certificate_chain_path" {
  description = "Path to the certificate chain file"
  type        = string
}