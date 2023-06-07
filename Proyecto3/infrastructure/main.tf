resource "azurerm_resource_group" "main" {
  name     = "ic4302-${var.group}"
  location = var.location["name"]
}
