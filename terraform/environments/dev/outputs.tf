output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = module.resource_group.resource_group_name
}

output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = module.networking.vnet_id
}

output "subnet_ids" {
  description = "IDs de las subredes creadas"
  value       = module.networking.subnet_ids
}

output "aks_cluster_id" {
  description = "ID del clúster de AKS"
  value       = module.aks.aks_id
}

output "apim_gateway_url" {
  description = "URL del API Gateway en API Management"
  value       = module.apim.apim_gateway_url
}

output "postgres_db_id" {
  description = "ID de la base de datos en PostgreSQL"
  value       = module.database.postgres_database_id
}

output "acr_name" {
  description = "Nombre del Azure Container Registry"
  value       = module.container_registry.acr_name
}

output "static_web_url" {
  description = "URL de la Static Web App desplegada"
  value       = module.static_web.static_web_url
}
