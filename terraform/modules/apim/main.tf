resource "azurerm_public_ip" "pip_apim" {
  name                = "pip-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.public_ip_zones
  domain_name_label   = "apim-extern-${var.prefix}"
}

resource "azurerm_api_management" "apim" {
  name                          = "apim-external-aks-${var.prefix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  publisher_name                = var.publisher_name
  publisher_email               = var.publisher_email
  sku_name                      = var.sku_name
  virtual_network_type          = var.virtual_network_type
  public_ip_address_id          = azurerm_public_ip.pip_apim.id
  public_network_access_enabled = var.public_network_access_enabled

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  depends_on = [var.nsg_association_dependency,var.subnet_id]
}

resource "azurerm_api_management_api" "api" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision           = "1"
  display_name       = var.display_name
  path               = var.api_path
  api_type           = "http"
  protocols          = ["http", "https"]
  service_url        = var.service_url

  import {
    content_format = "openapi"
    content_value  = file(var.openapi_spec_file)
  }

  subscription_required = var.subscription_required
  depends_on            = [azurerm_api_management.apim]
}

resource "azurerm_api_management_api_policy" "api_policy" {
  api_name            = azurerm_api_management_api.api.name
  api_management_name = azurerm_api_management_api.api.api_management_name
  resource_group_name = azurerm_api_management_api.api.resource_group_name
  xml_content         = templatefile("${path.module}/policy.xml", { client_id = var.client_id_server, tenant_id = var.tenant_id })
  depends_on          = [azurerm_api_management_api.api]
}
