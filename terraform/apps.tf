# Manages the Virtual Network
# Generate random value for the name
resource "random_string" "web_app_suffix" {
  length  = 3
  lower   = true
  numeric = false
  special = false
  upper   = false
}

# TODO: create region B (standby) and attach it to LB with failover rule
resource "azurerm_service_plan" "blog" {
  name                = "asp-${var.app_name}-${var.environment}"
  location            = azurerm_resource_group.blog.location
  resource_group_name = azurerm_resource_group.blog.name
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name # From standard (S1) support for autoscale
  
  tags = {
    environment = var.environment
    app_name = var.app_name
  }
}

resource "azurerm_linux_web_app" "blog" {
  name                = "app-${var.app_name}-${var.environment}-${random_string.web_app_suffix.result}"
  location            = azurerm_service_plan.blog.location
  resource_group_name = azurerm_service_plan.blog.resource_group_name
  service_plan_id = azurerm_service_plan.blog.id

  site_config {
    application_stack {
      # docker_image = "${azurerm_container_registry.blog.login_server}/ghost"
      docker_image = "ghost"
      docker_image_tag = "latest"

    }
    ftps_state = "Disabled"
    always_on        = var.web_app_always_on
    use_32_bit_worker = false
  }
  logs {
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs{
      file_system {
        retention_in_days = 1
        retention_in_mb = 100
      }
    }
  }
  # TODO: mount blob storage for static ghost files to /var/lib/ghost/content
  app_settings = {
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
      "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "1"
      "WEBSITES_PORT"                      = "2368"
      # "WEBSITE_SSL_REDIRECT"               = "true"
      # "WEBSITE_LOAD_CERTIFICATES"          = "${join(",", azurerm_key_vault_certificate.example.id)}"
      "database__client"                   = "mysql"
      "NODE_ENV" = "development"
      "url" = "http://localhost:80"
      "database__connection__host"         = azurerm_mysql_flexible_server.blog.fqdn
      "database__connection__database"      = azurerm_mysql_flexible_database.blog.name
      "database__connection__user"         = var.mysql_admin_username
      "database__connection__password"     = var.mysql_admin_password
      "database__connection__ssl__ca"     = trimspace(file("DigiCertGlobalRootCA.crt.pem"))
  }
  depends_on = [
    azurerm_mysql_flexible_database.blog, azurerm_container_registry.blog,
    azurerm_key_vault.blog
  ] 
  
  tags = {
    environment = var.environment
    app_name = var.app_name
  }
}

resource "azurerm_linux_web_app_slot" "blog" {
  name                = "staging-${var.app_name}-${var.environment}"
  app_service_id = azurerm_linux_web_app.blog.id
  
  site_config {
    application_stack {
      docker_image = "ghost"
      docker_image_tag = "latest"
    }
    ftps_state = "Disabled"
    always_on        = var.web_app_always_on
    use_32_bit_worker = false
  }
  
  logs {
    application_logs {
      file_system_level = "Verbose"
    }
    http_logs{
      file_system {
        retention_in_days = 1
        retention_in_mb = 100
      }
    }
  }
  
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "1"
    "WEBSITES_PORT"                      = "2368"
    "NODE_ENV" = "development"
    "url" = "http://localhost:80"
    "database__client"                   = "mysql"
    "database__connection__host"         = azurerm_mysql_flexible_server.blog.fqdn
    "database__connection__database"      = azurerm_mysql_flexible_database.blog.name
    "database__connection__user"         = var.mysql_admin_username
    "database__connection__password"     = var.mysql_admin_password
    "database__connection__ssl__ca"     = trimspace(file("DigiCertGlobalRootCA.crt.pem"))
  }
  depends_on = [azurerm_mysql_flexible_database.blog]
  
  tags = {
    environment = var.environment
    app_name = var.app_name
  }

}
### scaling
resource "azurerm_monitor_autoscale_setting" "blog" {
  name                = "autoscale-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_service_plan.blog.resource_group_name
  location            = azurerm_resource_group.blog.location
  target_resource_id  = azurerm_service_plan.blog.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    # TODO: add and/or http queue lenght rule
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.blog.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage" # consider HTTP
        metric_resource_id = azurerm_service_plan.blog.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 80
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
}    

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
    }
  }
}