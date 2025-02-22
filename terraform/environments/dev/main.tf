provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}
module "resource_group" {
  source   = "../../modules/resource_group"
  prefix   = var.prefix
  location = var.location
}

module "networking" {
  source              = "../../modules/networking"
  nsg_name            = "nsg-apim-${var.prefix}"
  location            = var.location
  resource_group_name         = module.resource_group.resource_group_name
  vnet_name           = "vnet-spoke"
  address_space       = ["10.10.0.0/16"]
  dns_servers         = null

  subnets = [
    {
      name             = "snet-aks"
      address_prefixes = ["10.10.0.0/24"]
    },
    {
      name             = "snet-apim"
      address_prefixes = ["10.10.1.0/24"]
    },
    {
      name             = "snet-db-postgres"
      address_prefixes = ["10.10.2.0/24"]
      service_endpoints = ["Microsoft.Storage"]
      delegation = {
        name = "fs"
        service_delegation = {
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }
  ]
  nsg_rules = [
    {
      name                        = "allow-inbound-infra-lb"
      access                      = "Allow"
      priority                    = 1000
      direction                   = "Inbound"
      protocol                    = "Tcp"
      source_address_prefix       = "AzureLoadBalancer"
      source_port_range           = "*"
      destination_address_prefix  = "VirtualNetwork"
      destination_port_range      = "6390"
    },
    {
      name                        = "allow-inbound-apim"
      access                      = "Allow"
      priority                    = 1010
      direction                   = "Inbound"
      protocol                    = "Tcp"
      source_address_prefix       = "ApiManagement"
      source_port_range           = "*"
      destination_address_prefix  = "VirtualNetwork"
      destination_port_range      = "3443"
    },
    {
      name                        = "allow-inbound-internet-http"
      access                      = "Allow"
      priority                    = 1020
      direction                   = "Inbound"
      protocol                    = "Tcp"
      source_address_prefix       = "Internet"
      source_port_range           = "*"
      destination_address_prefix  = "VirtualNetwork"
      destination_port_range      = "80"
    },
    {
      name                        = "allow-inbound-internet-https"
      access                      = "Allow"
      priority                    = 1030
      direction                   = "Inbound"
      protocol                    = "Tcp"
      source_address_prefix       = "Internet"
      source_port_range           = "*"
      destination_address_prefix  = "VirtualNetwork"
      destination_port_range      = "443"
    },
    {
      name                        = "allow-outbound-storage"
      access                      = "Allow"
      priority                    = 1020
      direction                   = "Outbound"
      protocol                    = "Tcp"
      source_address_prefix       = "VirtualNetwork"
      source_port_range           = "*"
      destination_address_prefix  = "Storage"
      destination_port_range      = "443"
    },
    {
      name                        = "allow-outbound-azure-sql"
      access                      = "Allow"
      priority                    = 1030
      direction                   = "Outbound"
      protocol                    = "Tcp"
      source_address_prefix       = "VirtualNetwork"
      source_port_range           = "*"
      destination_address_prefix  = "SQL"
      destination_port_range      = "1443"
    },
    {
      name                        = "allow-outbound-keyvault"
      access                      = "Allow"
      priority                    = 1040
      direction                   = "Outbound"
      protocol                    = "Tcp"
      source_address_prefix       = "VirtualNetwork"
      source_port_range           = "*"
      destination_address_prefix  = "AzureKeyVault"
      destination_port_range      = "443"
    }
  ]
}

module "container_registry" {
  source              = "../../modules/container_registry"
  prefix   = var.prefix
  resource_group_name         = module.resource_group.resource_group_name
  location           = var.location
  acr_sku            = "Basic"
}

module "aks" {
  source              = "../../modules/aks"
  aks_name            = "aks-dev-cluster-${var.prefix}"
  location            = var.location
  resource_group_name         = module.resource_group.resource_group_name
  dns_prefix          = "aks"
  kubernetes_version  = "1.30.0"
  private_cluster_enabled = false
  node_pool_name      = "mainpool"
  node_count          = 1
  vm_size             = "Standard_B2als_v2"
  os_sku              = "AzureLinux"
  vnet_subnet_id      = module.networking.subnet_ids["snet-aks"]
  acr_id              = module.container_registry.acr_id
}

module "apim" {
  source               = "../../modules/apim"
  api_name             = "quarkus-todo-api"
  display_name         = "Quarkus Todo API"
  api_path             = "api"
  service_url          = "http://10.10.0.10/api"
  subscription_required = false
  openapi_spec_file    = "../../test/openapi.yaml"
  prefix   = var.prefix
  location                    = var.location
  resource_group_name         = module.resource_group.resource_group_name
  publisher_name              = "My Company"
  publisher_email             = "test.armando@live.com"
  sku_name                    = "Developer_1"
  virtual_network_type        = "External"
  public_network_access_enabled = true
  subnet_id                   = module.networking.subnet_ids["snet-apim"]
  public_ip_zones             = ["1"]
  nsg_association_dependency  = module.networking.nsg_association
  client_id_server      = module.identity.resource_server_app_id
  tenant_id      = module.identity.azuread_tenant_id
}

module "identity" {
  source             = "../../modules/identity"
  static_web_app_url = module.static_web.static_web_url
}


module "database" {
  source                 = "../../modules/database"
  prefix   = var.prefix
  location               = var.location
  resource_group_name         = module.resource_group.resource_group_name
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  postgresql_version     = "14"
  administrator_login    = "adminuser"
  database_name          = var.database_name
  application_name       = "myapp"
  public_network_access_enabled = true
  zone                   = "1"
  aks_id = module.aks.aks_id
  aks_name = module.aks.aks_name
  workload_identity_name = module.container_registry.workload_identity_name
}


module "static_web" {
  source                 = "../../modules/static_web"
  prefix                 = var.prefix
  location               = var.location
  resource_group_name    = module.resource_group.resource_group_name
  github_repository      = var.github_repository_front
  azuread_client_id      = module.identity.client_app_id
  azuread_tenant_id      = module.identity.azuread_tenant_id
  api_management_url     = module.apim.apim_gateway_url
  api_path               = module.apim.api_path
}
module "service_deploy" {
  source                 = "../../modules/service_deploy"
  github_repository_api  = var.github_repository_api
  container_registry     = module.container_registry.acr_name
  aks_name               = module.aks.aks_name
  resource_group         = module.resource_group.resource_group_name
  subscription_id        = var.azure_subscription_id
  tenant_id              = module.identity.azuread_tenant_id
  acr_id                 = module.container_registry.acr_id
  script_executed        = module.database.script_executed
}
