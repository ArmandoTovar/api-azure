terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
