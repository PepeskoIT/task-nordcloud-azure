resource "azurerm_storage_account" "blog" {
  name                     = "st${var.app_name}${var.environment}"
  resource_group_name      = azurerm_resource_group.blog.name
  location                 = azurerm_resource_group.blog.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  
  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}