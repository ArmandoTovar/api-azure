resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  depends_on          = [var.resource_group_name]
}

resource "azurerm_subnet" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

  service_endpoints = lookup(each.value, "service_endpoints", null)
  depends_on        = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [var.resource_group_name]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnets["snet-apim"].id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on                = [azurerm_network_security_group.nsg]
}

# Definir reglas de NSG de manera dinámica usando listas de objetos
resource "azurerm_network_security_rule" "rules" {
  for_each                    = { for rule in var.nsg_rules : rule.name => rule }
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  name                        = each.value.name
  access                      = each.value.access
  priority                    = each.value.priority
  direction                   = each.value.direction
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range      = each.value.destination_port_range
  depends_on                  = [azurerm_subnet.subnets]
}

