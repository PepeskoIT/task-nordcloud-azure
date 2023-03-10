terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mydemo-shared-002"
    storage_account_name = "stmydemoshared002"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
