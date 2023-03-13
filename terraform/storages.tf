resource "random_string" "st_suffix" {
  length  = 3
  lower   = false
  numeric = true
  special = false
  upper   = false
}

resource "azurerm_storage_account" "blog" {
  name                     = "st${var.app_name}${var.environment}${random_string.st_suffix.result}"
  resource_group_name      = azurerm_resource_group.blog.name
  location                 = azurerm_resource_group.blog.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  
  network_rules {
    default_action             = "Deny"
    ip_rules                   = [var.control_host_pub_ip]
    virtual_network_subnet_ids = [azurerm_subnet.blog.id]
  }

  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}

resource "azurerm_storage_account" "delete_posts" {
  name                     = "stfunc${var.app_name}${var.environment}${random_string.st_suffix.result}"
  resource_group_name      = azurerm_resource_group.delete_posts.name
  location                 = azurerm_resource_group.delete_posts.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [var.control_host_pub_ip]
    virtual_network_subnet_ids = [azurerm_subnet.blog.id]
  }

  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}