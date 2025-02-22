output "github_sp_secret" {
  value     = azuread_service_principal_password.github_sp_secret.value
  sensitive = true
}
