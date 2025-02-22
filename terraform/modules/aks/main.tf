resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = var.dns_prefix
  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
  }

  oidc_issuer_enabled = true
  default_node_pool {
    name           = var.node_pool_name
    node_count     = var.node_count
    vm_size        = var.vm_size
    os_sku         = var.os_sku
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.upgrade_settings
    ]
  }
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}

resource "azurerm_role_assignment" "acr_role" {
  principal_id                      = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name               = "AcrPull"
  scope                               = var.acr_id
}

resource "terraform_data" "aks_get_credentials" {
  triggers_replace = [azurerm_kubernetes_cluster.aks.id]
  provisioner "local-exec" {
    command = <<EOT
      az aks get-credentials -n ${azurerm_kubernetes_cluster.aks.name} -g ${azurerm_kubernetes_cluster.aks.resource_group_name} --overwrite-existing
      az aks approuting enable --resource-group ${azurerm_kubernetes_cluster.aks.resource_group_name} --name ${azurerm_kubernetes_cluster.aks.name}
      az aks enable-addons --addons http_application_routing --resource-group ${azurerm_kubernetes_cluster.aks.resource_group_name} --name ${azurerm_kubernetes_cluster.aks.name}
    EOT
  }
}
