output "postgres_server_id" {
  description = "ID del servidor PostgreSQL"
  value       = azurerm_postgresql_flexible_server.postgres.id
}

output "postgres_database_id" {
  description = "ID de la base de datos PostgreSQL"
  value       = azurerm_postgresql_flexible_server_database.database.id
}

output "postgres_admin_username" {
  description = "Nombre de usuario administrador de PostgreSQL"
  value       = azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "postgres_admin_password" {
  description = "Contraseña del usuario administrador de PostgreSQL"
  value       = random_password.password.result
  sensitive   = true
}
output "script_executed" {
  description = "Script conector db ejecutado"
  value       = terraform_data.post_create_connection
}
