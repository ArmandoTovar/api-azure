output "client_app_id" {
  description = "ID de la aplicación client-1"
  value       = azuread_application.client-1.client_id
}
output "azuread_tenant_id" {
  description = "ID del tenant de Azure AD"
  value       = data.azuread_client_config.current.tenant_id
}

output "resource_server_app_id" {
  description = "ID de la aplicación resource-server-1"
  value       = azuread_application.resource-server-1.client_id
}

output "client_service_principal_id" {
  description = "ID del Service Principal de client-1"
  value       = azuread_service_principal.client-1.object_id
}

output "resource_server_service_principal_id" {
  description = "ID del Service Principal de resource-server-1"
  value       = azuread_service_principal.resource-server-1.object_id
}
