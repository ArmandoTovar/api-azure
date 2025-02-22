variable "aks_name" {
  description = "Nombre del AKS"
  type        = string
}

variable "location" {
  description = "Ubicación del AKS"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  type        = string
}

variable "dns_prefix" {
  description = "Prefijo DNS para el AKS"
  type        = string
  default     = "aks"
}

variable "kubernetes_version" {
  description = "Versión de Kubernetes"
  type        = string
  default     = "1.30.0"
}

variable "private_cluster_enabled" {
  description = "Habilitar clúster privado"
  type        = bool
  default     = false
}

variable "node_pool_name" {
  description = "Nombre del node pool"
  type        = string
  default     = "mainpool"
}

variable "node_count" {
  description = "Cantidad de nodos"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B2als_v2"
}

variable "os_sku" {
  description = "Sistema operativo de los nodos"
  type        = string
  default     = "AzureLinux"
}

variable "vnet_subnet_id" {
  description = "ID de la subred de la VNet"
  type        = string
}

variable "acr_id" {
  description = "ID del Azure Container Registry"
  type        = string
}
