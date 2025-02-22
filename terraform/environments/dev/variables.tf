# Azure Configuración
variable "prefix" {
  description = "Prefijo para los recursos de Azure"
  type        = string
  default     = "mytestapparmando"
}
variable "azure_subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "location" {
  description = "Ubicación de los recursos en Azure"
  type        = string
  default     = "East US 2"
}

# GitHub Configuración
variable "github_token" {
  description = "Token de acceso a GitHub"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "Propietario del repositorio de GitHub"
  type        = string
}


variable "github_repository_front" {
  description = "Nombre del repositorio Front de GitHub"
  type        = string
}
variable "github_repository_api" {
  description = "Nombre del repositorio API de GitHub"
  type        = string
}
# Red Configuración
variable "infra_subnet_address_space" {
  description = "Espacio de direcciones de la subred de infraestructura"
  type        = string
  default     = "192.0.0.0/8"
}

variable "aks_subnet_address_space" {
  description = "Espacio de direcciones de la subred de AKS"
  type        = string
  default     = "191.0.0.0/8"
}

variable "azurerm_private_dns_zone_name" {
  description = "Nombre de la zona privada de DNS"
  type        = string
  default     = "private.azure.com"
}

variable "private_endpoint_name" {
  description = "Nombre del endpoint privado"
  type        = string
  default     = "psql-private-dev"
}

variable "private_dns_zone_group_name" {
  description = "Grupo de la zona privada de DNS"
  type        = string
  default     = "private-dns-zone-group-dev"
}

variable "private_service_connection_name" {
  description = "Nombre de la conexión privada de servicio"
  type        = string
  default     = "private-service-connection-dev"
}

variable "private_dns_record_a_name_psql" {
  description = "Nombre del registro A de la zona DNS privada para PostgreSQL"
  type        = string
  default     = "psql"
}

# Base de Datos Configuración
variable "database_server_name" {
  description = "Nombre del servidor de la base de datos"
  type        = string
  default     = "postgresql-armando-server"
}

variable "database_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "db-dev"
}

variable "postgres_sku_name" {
  description = "SKU del servidor PostgreSQL"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "admin_username" {
  description = "Nombre del administrador de PostgreSQL"
  type        = string
  default     = "terraform"
}

variable "aad_administrator_name" {
  description = "Administrador AAD de la base de datos"
  type        = string
  default     = "spring"
}

variable "admin_password" {
  description = "Contraseña del administrador de PostgreSQL"
  type        = string
  sensitive   = true
}

variable "storage_mb" {
  description = "Tamaño del almacenamiento de la base de datos"
  type        = number
  default     = 32768
}

# AKS Configuración
variable "cluster_name" {
  description = "Nombre del clúster AKS"
  type        = string
  default     = "k8s-cluster"
}

variable "vm_size" {
  description = "Tamaño de la máquina virtual en AKS"
  type        = string
  default     = "Standard_B2als_v2"
}

variable "node_pool_name" {
  description = "Nombre del pool de nodos de AKS"
  type        = string
  default     = "devpool1"
}

variable "aks_dns_service_ip" {
  description = "Dirección IP del servicio DNS de AKS"
  type        = string
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR del puente Docker en AKS"
  type        = string
  default     = "172.0.0.1/8"
}

variable "aks_pod_cidr" {
  description = "CIDR de los pods en AKS"
  type        = string
  default     = null
}

variable "aks_service_cidr" {
  description = "CIDR del servicio en AKS"
  type        = string
  default     = "10.0.0.0/16"
}
