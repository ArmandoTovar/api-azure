resource "azurerm_container_registry" "acr" {
  name                = "register${var.prefix}"
  resource_group_name = var.resource_group_name
  location           = var.location
  sku                = var.acr_sku
}

resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "workload-identity-${var.prefix}"
  resource_group_name = var.resource_group_name
  location            = var.location
}
