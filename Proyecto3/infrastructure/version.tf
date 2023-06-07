# Configure the Azure provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.47.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
#  skip_provider_registration = "true"
  features {}
}
