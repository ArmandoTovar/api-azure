variable "prefix" {
  description = "Prefijo para el nombre de la Static Web App"
  type        = string
}

variable "location" {
  description = "Ubicación de la Static Web App"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "preview_environments_enabled" {
  description = "Habilitar entornos de vista previa en Azure Static Web Apps"
  type        = bool
  default     = true
}

variable "sku_tier" {
  description = "Tipo de SKU para Azure Static Web Apps"
  type        = string
  default     = "Free"
}

variable "sku_size" {
  description = "Tamaño de SKU para Azure Static Web Apps"
  type        = string
  default     = "Free"
}

variable "environment" {
  description = "Nombre del entorno"
  type        = string
  default     = "main"
}

variable "app_location" {
  description = "Ubicación de la aplicación frontend"
  type        = string
  default     = "/"
}

variable "api_location" {
  description = "Ubicación de la API en el repositorio"
  type        = string
  default     = "/"
}

variable "output_location" {
  description = "Ubicación de los archivos de salida de la compilación"
  type        = string
  default     = "dist"
}

variable "github_repository" {
  description = "Nombre del repositorio de GitHub"
  type        = string
}

variable "azuread_client_id" {
  description = "Client ID de la aplicación en Azure AD"
  type        = string
}

variable "azuread_tenant_id" {
  description = "Tenant ID de la aplicación en Azure AD"
  type        = string
}

variable "api_management_url" {
  description = "URL del API Gateway en API Management"
  type        = string
}

variable "api_path" {
  description = "Path de la API en API Management"
  type        = string
}
