variable "github_token" {
  description = "Token de autenticación para GitHub"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "Nombre del propietario del repositorio de GitHub"
  type        = string
}

variable "azure_subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}
