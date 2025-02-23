resource "azuread_application" "github_sp" {
  display_name = "github-terraform-sp"
}

resource "azuread_service_principal" "github_sp" {
  client_id = azuread_application.github_sp.client_id
}

resource "azuread_service_principal_password" "github_sp_secret" {
  service_principal_id = azuread_service_principal.github_sp.id
}

resource "azurerm_role_assignment" "github_sp_acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github_sp.object_id
}

resource "azurerm_role_assignment" "github_sp_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_sp.object_id
}

locals {
  azure_credentials = jsonencode({
    clientId                     = azuread_application.github_sp.client_id
    clientSecret                 = azuread_service_principal_password.github_sp_secret.value
    subscriptionId               = var.subscription_id
    tenantId                     = var.tenant_id
    resourceManagerEndpointUrl   = "https://management.azure.com/"
  })
}

resource "github_actions_secret" "azure_credentials" {
  repository      = var.github_repository_api
  secret_name     = "AZURE_CREDENTIALS"
  plaintext_value = local.azure_credentials
}
resource "github_actions_variable" "container_registry" {
  repository = var.github_repository_api
  variable_name       = "CONTAINER_REGISTRY"
  value      = var.container_registry
  depends_on = [
    var.container_registry
  ]
}
resource "github_actions_variable" "aks_name" {
  repository = var.github_repository_api
  variable_name       = "AKS_NAME"
  value      = var.aks_name
  depends_on = [
    var.aks_name]
}
resource "github_actions_variable" "resource_group_api" {
  repository = var.github_repository_api
  variable_name       = "RESOURCE_GROUP"
  value      = var.resource_group
  depends_on = [
    var.resource_group
  ]
}


data "external" "get_service_account" {
  program = ["bash", "-c", <<EOT
    CLIENT_ID=$(az aks connection show --connection akspostgresconn --name ${var.aks_name} --resource-group ${var.resource_group} --output json | grep -o '"clientId": "[^"]*' | sed 's/"clientId": "//')
    echo "{ \"clientId\": \"$CLIENT_ID\" }"
  EOT
  ]
}
resource "github_actions_variable" "service_account_name" {
  repository    = var.github_repository_api
  variable_name = "SERVICE_ACCOUNT_NAME"
  value         = data.external.get_service_account.result["clientId"]
}

resource "github_repository_file" "deploy_quarkus_yml" {
  repository      = var.github_repository_api
  branch         = "main"
  file           = ".github/workflows/deploy-quarkus.yml"
  content        = templatefile("${path.module}/deploy-quarkus.tpl",
    {
      container_registry = var.container_registry
      github_repo        = var.github_repository_api
      aks_name           = var.aks_name
      resource_group     = var.resource_group
    }
  )
  commit_message      = "Add Quarkus deployment workflow (by Terraform)"
  commit_author       = "Armando Tovar"
  commit_email        = "tovi61xd@gmail.com"
  overwrite_on_create = true

  depends_on = [
    github_actions_secret.azure_credentials,
    github_actions_variable.container_registry,
    github_actions_variable.aks_name,
    github_actions_variable.resource_group_api,
    github_actions_variable.service_account_name
  ]
}
