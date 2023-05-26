resource "azurerm_service_plan" "main" {
  name                = "main-${var.group}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "S1"
}
resource "azurerm_linux_web_app" "main" {
  name                = "main-${var.group}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false",
    "AZURE_CLIENT_ID"                     = "${azurerm_user_assigned_identity.main.client_id}"
  }
  site_config {
    application_stack {
      docker_image     = "docker.io/moisose/open-lyrics"
      docker_image_tag = "latest"
    }
  }
}

