output "apim_id" {
  description = "ID del servicio API Management"
  value       = azurerm_api_management.apim.id
}

output "apim_name" {
  description = "Nombre del servicio API Management"
  value       = azurerm_api_management.apim.name
}

output "apim_gateway_url" {
  description = "URL del gateway de APIM"
  value       = azurerm_api_management.apim.gateway_url
}

output "public_ip_id" {
  description = "ID de la dirección IP pública de APIM"
  value       = azurerm_public_ip.pip_apim.id
}
output "api_id" {
  description = "ID de la API creada en API Management"
  value       = azurerm_api_management_api.api.id
}

output "api_name" {
  description = "Nombre de la API"
  value       = azurerm_api_management_api.api.name
}


output "api_path" {
  description = "Ruta de la API"
  value       = azurerm_api_management_api.api.path
}
