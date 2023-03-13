# TODO: finish firewall and health-probe config, consider custom domain settings
# Configure switch-over for both function and web app
resource "azurerm_dns_zone" "blog" {
  name                = "sub-domain.someexamplename.com"
  resource_group_name = azurerm_resource_group.blog.name
}

resource "azurerm_cdn_frontdoor_profile" "blog" {
  name                = "example-profile"
  resource_group_name = azurerm_resource_group.blog.name
  sku_name            = "Standard_AzureFrontDoor"
  
  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "blog" {
  name                     = "example-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.blog.id

  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "blog" {
  name                     = "example-originGroup"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.blog.id
  session_affinity_enabled = true

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10

  health_probe {
    interval_in_seconds = 240
    path                = "/healthProbe"
    protocol            = "Https"
    request_type        = "GET"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 16
    successful_samples_required        = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "blog" {
  name                          = "example-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.blog.id
  enabled                       = true

  certificate_name_check_enabled = false

  host_name          = azurerm_cdn_frontdoor_endpoint.blog.host_name
  http_port          = 80
  https_port         = 443
  origin_host_header = "someexamplename.com"
  priority           = 1
  weight             = 500
}

resource "azurerm_cdn_frontdoor_custom_domain" "blog" {
  name                     = "example-customDomain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.blog.id
  dns_zone_id              = azurerm_dns_zone.blog.id
  host_name                = "blog.someexamplename.com"

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}