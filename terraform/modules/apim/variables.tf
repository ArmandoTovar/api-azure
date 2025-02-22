variable "prefix" {
  description = "Prefijo para nombrar los recursos de APIM"
  type        = string
}

variable "location" {
  description = "Ubicación del recurso APIM"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "publisher_name" {
  description = "Nombre del publicador de APIM"
  type        = string
  default     = "My Company"
}

variable "publisher_email" {
  description = "Correo electrónico del publicador de APIM"
  type        = string
  default     = "test.armando@live.com"
}

variable "sku_name" {
  description = "Tipo de SKU de APIM"
  type        = string
  default     = "Developer_1"
}

variable "virtual_network_type" {
  description = "Tipo de conexión de red para APIM (None, External, Internal)"
  type        = string
  default     = "External"
}

variable "public_network_access_enabled" {
  description = "Habilitar acceso público a APIM"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "ID de la subred donde se desplegará APIM"
  type        = string
}

variable "public_ip_zones" {
  description = "Zonas de disponibilidad del Public IP"
  type        = list(string)
  default     = ["1"]
}

variable "nsg_association_dependency" {
  description = "Dependencia para garantizar que el NSG está asociado antes de APIM"
  type        = any
}
variable "api_name" {
  description = "Nombre de la API en API Management"
  type        = string
}
variable "client_id_server" {
  description = "ID del cliente de la API"
  type        = string
}
variable "tenant_id" {
  description = "ID del tenant de la API"
  type        = string
}

variable "display_name" {
  description = "Nombre legible de la API"
  type        = string
}

variable "api_path" {
  description = "Ruta de la API"
  type        = string
}

variable "service_url" {
  description = "URL del backend de la API"
  type        = string
}

variable "subscription_required" {
  description = "Define si la API requiere suscripción"
  type        = bool
  default     = false
}


variable "openapi_spec_file" {
  description = "Ruta del archivo OpenAPI YAML o JSON"
  type        = string
}
