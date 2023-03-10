resource "azurerm_storage_account" "delete_posts" {
  name                     = "linuxfunctionappsa"
  resource_group_name      = azurerm_resource_group.blog.name
  location                 = azurerm_resource_group.blog.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "delete_posts" {
  name                = "asp-delete-posts-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.blog.name
  location            = azurerm_resource_group.blog.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "delete_posts" {
  name                = "func-delete-posts-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.blog.name
  location            = azurerm_resource_group.blog.location

  storage_account_name       = azurerm_storage_account.blog.name
  storage_account_access_key = azurerm_storage_account.blog.primary_access_key
  service_plan_id            = azurerm_service_plan.blog.id

  site_config {}
}