data "azurerm_client_config" "blog" {}

resource "azurerm_resource_group" "blog" {
  name     = "rg-${var.app_name}-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
    app_name = var.app_name

  }
}

resource "azurerm_resource_group" "delete_posts" {
  name     = "rg-${var.app_name}-function-${var.environment}"
  location = var.location
  tags = {
    environment = var.environment
    app_name = var.app_name

  }
}