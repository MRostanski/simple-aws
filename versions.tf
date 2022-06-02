terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      version = "~> 4.16.0"
      source  = "hashicorp/aws"
    }
    helm = {
      version = "~> 2.5.1"
      source  = "hashicorp/helm"
    }
    kubernetes = {
      version = "~> 2.11.0"
      source  = "hashicorp/kubernetes"
    }
  }
}