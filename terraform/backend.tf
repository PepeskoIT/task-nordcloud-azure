terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mydemo-shared"
    storage_account_name = "stmydemoshared12001232"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
