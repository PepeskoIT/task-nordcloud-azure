resource "azurerm_key_vault" "blog" {
  name                = "kv-${var.app_name}-${var.environment}"
  location                    = azurerm_resource_group.blog.location
  resource_group_name         = azurerm_resource_group.blog.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.blog.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.blog.tenant_id
    object_id = data.azurerm_client_config.blog.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  # TODO: firewall/route/access rules for web app and pipelines usage.
  # Enable logging.
  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}