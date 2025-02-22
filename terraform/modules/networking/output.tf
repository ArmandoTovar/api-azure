output "nsg_id" {
  description = "ID del Network Security Group"
  value       = azurerm_network_security_group.nsg.id
}
output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "IDs de las subredes creadas"
  value = { for subnet in azurerm_subnet.subnets : subnet.name => subnet.id }
}
output "nsg_association" {
  description = "Dependencia para garantizar que el NSG está asociado antes de APIM"
  value = azurerm_subnet_network_security_group_association.nsg_association
}
