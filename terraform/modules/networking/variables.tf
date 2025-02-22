variable "nsg_name" {
  description = "Nombre del Network Security Group"
  type        = string
}

variable "location" {
  description = "Ubicación del recurso"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}


variable "nsg_rules" {
  description = "Lista de reglas de seguridad para el NSG"
  type = list(object({
    name                        = string
    access                      = string
    priority                    = number
    direction                   = string
    protocol                    = string
    source_address_prefix       = string
    source_port_range           = string
    destination_address_prefix  = string
    destination_port_range      = string
  }))
}

variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
}


variable "address_space" {
  description = "Espacio de direcciones de la VNet"
  type        = list(string)
}

variable "dns_servers" {
  description = "Servidores DNS de la VNet"
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Lista de subredes a crear en la VNet"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    service_endpoints = optional(list(string))
    delegation = optional(object({
      name               = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
}
