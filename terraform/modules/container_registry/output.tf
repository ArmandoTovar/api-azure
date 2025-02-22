output "acr_id" {
  description = "ID del Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  description = "Nombre del Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "workload_identity_id" {
  description = "ID de la identidad asignada al workload"
  value       = azurerm_user_assigned_identity.workload_identity.id
}

output "workload_identity_name" {
  description = "Nombre de la identidad asignada al workload"
  value       = azurerm_user_assigned_identity.workload_identity.name
}
