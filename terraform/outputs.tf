output "azurerm_web_app_server" {
  value = azurerm_linux_web_app.blog.name
}

output "azurerm_mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.blog.name
}

output "azurerm_storage_account_blog" {
  value = azurerm_storage_account.blog.name
}

output "azurerm_storage_account_delete_posts" {
  value = azurerm_storage_account.delete_posts.name
}