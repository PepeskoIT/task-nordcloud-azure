resource "azurerm_container_registry" "blog" {
  name                = "acr${var.app_name}${var.environment}"
  resource_group_name = azurerm_resource_group.blog.name
  location            = azurerm_resource_group.blog.location
  sku                 = var.container_registry_sku_name
  
  georeplications {
    location                = var.replication_location
    zone_redundancy_enabled = false
    tags                    = {
      environment = var.environment
      app_name = var.app_name
      region = "B"
  }
  }

  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
  #TODO: add firewall rules and add encryption
}