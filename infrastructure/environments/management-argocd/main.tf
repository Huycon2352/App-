terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.36.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }

    helm = {
      source = "hashicorp/helm"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "terraform_remote_state" "management" {
  backend = "s3"

  config = {
    bucket = "terraform-state-voting-app-123456"
    key    = "management-infra/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_eks_cluster_auth" "this" {
  name = data.terraform_remote_state.management.outputs.cluster_name
}

provider "kubernetes" {
  host = data.terraform_remote_state.management.outputs.cluster_endpoint

  token = data.aws_eks_cluster_auth.this.token

  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.management.outputs.cluster_ca
  )
}

provider "helm" {
  kubernetes {
    host = data.terraform_remote_state.management.outputs.cluster_endpoint

    token = data.aws_eks_cluster_auth.this.token

    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.management.outputs.cluster_ca
    )
  }
}

module "argocd" {
  source = "../../modules/argocd"

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}