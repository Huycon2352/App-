terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      configuration_aliases = [ kubernetes ]
    }
     time = {
      source = "hashicorp/time"
    }
  }
}