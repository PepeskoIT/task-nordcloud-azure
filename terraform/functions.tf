
# TODO: add redundancy to seconday region
# TODO: create region B (standby) and attach it to LB with failover rule
resource "azurerm_service_plan" "delete_posts" {
  name                = "asp-delete-posts-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.delete_posts.name
  location            = azurerm_resource_group.delete_posts.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "delete_posts" {
  name                = "func-delete-posts-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.delete_posts.name
  location            = azurerm_resource_group.delete_posts.location

  storage_account_name       = azurerm_storage_account.delete_posts.name
  storage_account_access_key = azurerm_storage_account.delete_posts.primary_access_key
  service_plan_id            = azurerm_service_plan.delete_posts.id

  # TODO: add auth, add http trigger, functions should use Ghost API 
  # https://ghost.org/docs/admin-api/. Body could look something like:
  # 1. GET /admin/posts/
  # 2. for post in posts
  # 3.  DELETE /admin/posts/{post.id}/

  site_config {}

  depends_on = [
    azurerm_linux_web_app.blog
  ]

  tags = {
    environment = var.environment
    app_name = var.app_name
    region = "A"
  }
}