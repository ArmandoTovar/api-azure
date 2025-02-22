output "aks_id" {
  description = "ID del clúster AKS"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_name" {
  description = "Nombre del AKS"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kubeconfig" {
  description = "Archivo Kubeconfig para el AKS"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
