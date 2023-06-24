terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.62.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "satfstateosticket"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

