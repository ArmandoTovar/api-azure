output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "ID del grupo de recursos"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_location" {
  description = "Ubicación del grupo de recursos"
  value       = azurerm_resource_group.rg.location
}
