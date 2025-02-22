variable "prefix" {
  description = "Prefijo utilizado en los nombres de los recursos"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos donde se creará el ACR"
  type        = string
}

variable "location" {
  description = "Ubicación del recurso en Azure"
  type        = string
}

variable "acr_sku" {
  description = "Tipo de SKU del Azure Container Registry"
  type        = string
  default     = "Basic"
}
