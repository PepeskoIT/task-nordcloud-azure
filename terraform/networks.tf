# Manages the Virtual Network

resource "azurerm_virtual_network" "blog" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.blog.location
  name                = "vnet-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.blog.name
  tags = {
    environment = var.environment
    app_name = var.app_name
  }
}

# Manages the Subnet
resource "azurerm_subnet" "blog" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "subnet-${var.app_name}-${var.environment}"
  resource_group_name  = azurerm_resource_group.blog.name
  virtual_network_name = azurerm_virtual_network.blog.name
  service_endpoints    = [
    "Microsoft.Storage", "Microsoft.Sql", "Microsoft.ContainerRegistry",
    "Microsoft.Web", "Microsoft.KeyVault"
    ]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}
