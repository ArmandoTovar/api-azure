
variable "prefix" {
  description = "Prefijo del servidor PostgreSQL"
  type        = string
}

variable "location" {
  description = "Ubicación del recurso"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "sku_name" {
  description = "Plan de SKU del servidor PostgreSQL"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Tamaño del almacenamiento en MB"
  type        = number
  default     = 32768
}

variable "postgresql_version" {
  description = "Versión de PostgreSQL"
  type        = string
  default     = "14"
}

variable "administrator_login" {
  description = "Usuario administrador del servidor PostgreSQL"
  type        = string
}

variable "database_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "application_name" {
  description = "Nombre de la aplicación"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Habilitar acceso público a PostgreSQL"
  type        = bool
  default     = true
}

variable "zone" {
  description = "Zona de disponibilidad de PostgreSQL"
  type        = string
  default     = "1"
}

variable "aks_id" {
  description = "ID del clúster AKS"
  type        = string
}
variable "aks_name" {
  description = "Nombre del clúster AKS"
  type        = string
}
variable "workload_identity_name" {
  description = "Nombre de la identidad de trabajo"
  type        = string
}
