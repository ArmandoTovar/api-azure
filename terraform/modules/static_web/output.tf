output "static_web_url" {
  description = "URL de la Static Web App desplegada"
  value       = azurerm_static_web_app.static_front.default_host_name
}

output "static_web_api_token" {
  description = "API Key de la Static Web App"
  value       = azurerm_static_web_app.static_front.api_key
  sensitive   = true
}
