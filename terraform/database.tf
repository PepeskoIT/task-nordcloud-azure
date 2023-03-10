resource "azurerm_mysql_flexible_server" "blog" {
  name                = "mysqlfl-${var.app_name}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.blog.name
  version             = "8.0.21"
  administrator_login = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  sku_name = var.mysql_server_sku_name 
  backup_retention_days = var.mysql_server_backup_retention_days
  geo_redundant_backup_enabled = var.mysql_server_geo_redundand

  dynamic "high_availability" {
    for_each = var.mysql_server_high_availability == null ? [] : [1]
    content {
      mode = var.mysql_server_high_availability.mode
      standby_availability_zone = var.mysql_server_high_availability.standby_availability_zone
    }
  }
  zone = 1  # "Error: `zone` cannot be changed independently" if omitted

  dynamic "maintenance_window" {
    for_each = var.mysql_server_maintenance_window == null ? [] : [1]
    content {
      day_of_week = var.mysql_server_maintenance_window.day_of_week
      start_hour = var.mysql_server_maintenance_window.start_hour
      start_minute = var.mysql_server_maintenance_window.start_minute
    }
  }

  # NOTE: consider Autoscale IOPS (preview)
  storage {
    auto_grow_enabled = var.mysql_server_auto_grow_enabled
    iops    = var.mysql_server_iops_size
    size_gb = var.mysql_server_storage_size
  }

  # depends_on = [azurerm_private_dns_zone_virtual_network_link.blog]
  
  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}

resource "azurerm_mysql_flexible_database" "blog" {
  name                = "ghost"
  resource_group_name = azurerm_mysql_flexible_server.blog.resource_group_name
  server_name         = azurerm_mysql_flexible_server.blog.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "blog" {
  for_each = toset(azurerm_linux_web_app.blog.outbound_ip_address_list)
  name                = "mysqlfl-fw-rule-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_mysql_flexible_server.blog.resource_group_name
  server_name         = azurerm_mysql_flexible_server.blog.name
  start_ip_address    = each.key # TODO: put specific address
  end_ip_address      = each.key # TODO: put specific address
}
