resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

data "azurerm_client_config" "current" {}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                = "db-server-${var.prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  storage_mb          = var.storage_mb
  version            = var.postgresql_version
  administrator_login = var.administrator_login
  administrator_password = random_password.password.result
  public_network_access_enabled = var.public_network_access_enabled
  zone                   = var.zone

  authentication {
    password_auth_enabled         = true
    active_directory_auth_enabled = true
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.database_name
  charset   = "utf8"
  collation = "en_US.utf8"
  server_id = azurerm_postgresql_flexible_server.postgres.id
}

data "http" "myip" {
  url = "http://whatismyip.akamai.com"
}

locals {
  myip = chomp(data.http.myip.response_body)
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_clientip" {
  name             = "${var.application_name}-deployagent"
  start_ip_address = local.myip
  end_ip_address   = local.myip
  server_id        = azurerm_postgresql_flexible_server.postgres.id
}

resource "terraform_data" "post_create_connection" {
  triggers_replace = [
    var.aks_id,
  ]

  provisioner "local-exec" {
    command = <<EOT
      az provider register --namespace Microsoft.ServiceLinker --wait
      az provider register --namespace Microsoft.KubernetesConfiguration --wait
      az extension add --name serviceconnector-passwordless --upgrade --allow-preview true
      az aks connection create postgres-flexible \
        --connection akspostgresconn \
        --kube-namespace default \
        --source-id $(az aks show --resource-group ${var.resource_group_name} --name ${var.aks_name} --query id --output tsv) \
        --target-id $(az postgres flexible-server show --resource-group ${var.resource_group_name} --name ${azurerm_postgresql_flexible_server.postgres.name} --query id --output tsv)/databases/${var.database_name} \
        --workload-identity $(az identity show --resource-group ${var.resource_group_name} --name ${var.workload_identity_name} --query id --output tsv)
    EOT
  }

  depends_on = [
    azurerm_postgresql_flexible_server.postgres,
    azurerm_postgresql_flexible_server_database.database,
    var.aks_id,
    azurerm_postgresql_flexible_server_firewall_rule.firewall_clientip
  ]
}
