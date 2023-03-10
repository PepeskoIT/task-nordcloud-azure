output "azurerm_web_app_server" {
  value = azurerm_linux_web_app.blog.name
}

output "azurerm_mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.blog.name
}