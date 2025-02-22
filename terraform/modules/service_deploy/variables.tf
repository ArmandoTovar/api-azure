variable "github_repository_api" {
  description = "Nombre del repositorio en GitHub donde se configuran las variables de entorno"
  type        = string
}

variable "container_registry" {
  description = "URL del Container Registry en Azure"
  type        = string
}
variable "aks_name" {
  description = "Nombre del cluster AKS"
  type        = string
}

variable "resource_group" {
  description = "Grupo de recursos en Azure"
  type        = string
}

variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "ID de tenant de Azure"
  type        = string
}
variable "acr_id" {
  description = "ID del Container Registry en Azure"
  type        = string
}
variable "script_executed" {
  description = "Script conector ejecutado"
  type        = any 
}
