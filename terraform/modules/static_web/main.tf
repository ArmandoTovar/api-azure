resource "azurerm_static_web_app" "static_front" {
  name                          = "static-front-${var.prefix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  preview_environments_enabled  = var.preview_environments_enabled
  sku_tier                      = var.sku_tier
  sku_size                      = var.sku_size

  app_settings = {
    environment     = var.environment
    app_location    = var.app_location
    output_location = var.output_location
  }
}

# GitHub Actions: Configuración de secretos y variables de entorno
resource "github_actions_secret" "publishprofile" {
  repository      = var.github_repository
  secret_name     = "AZURE_STATIC_WEB_APPS_API_TOKEN"
  plaintext_value = azurerm_static_web_app.static_front.api_key

  depends_on = [
    azurerm_static_web_app.static_front  # Asegura que la Static Web App ya fue creada
  ]
}

resource "github_actions_variable" "vite_msal_client_id" {
  repository    = var.github_repository
  variable_name = "VITE_MSAL_CLIENT_ID"
  value         = var.azuread_client_id
  depends_on = [

    azurerm_static_web_app.static_front,
    var.azuread_client_id
  ]

}

resource "github_actions_variable" "vite_msal_tenant_id" {
  repository    = var.github_repository
  variable_name = "VITE_MSAL_TENANT_ID"
  value         =var.azuread_tenant_id
  depends_on = [
    azurerm_static_web_app.static_front,
    var.azuread_tenant_id
  ]
}

resource "github_actions_variable" "vite_msal_redirect_uri" {
  repository    = var.github_repository
  variable_name = "VITE_MSAL_REDIRECT_URI"
  value         = "https://${azurerm_static_web_app.static_front.default_host_name}/"

  depends_on = [
    azurerm_static_web_app.static_front
  ]
}

resource "github_actions_variable" "vite_msal_scope" {
  repository    = var.github_repository
  variable_name = "VITE_MSAL_SCOPE"
  value         = "api://api-todo/resource-server-1.scope-1"
}

resource "github_actions_variable" "vite_api_url" {
  repository    = var.github_repository
  variable_name = "VITE_API_URL"
  value         = "${var.api_management_url}/${var.api_path}"

  depends_on = [
    var.api_management_url
  ]
}

# Configuración de GitHub Actions Workflow
resource "github_repository_file" "azure_static_web_app_yml" {
  repository      = var.github_repository
  branch         = "main"
  file           = ".github/workflows/azure-static-web-apps.yml"
  content        = templatefile("${path.module}/azure-static-web-app.tpl",
    {
      app_location    = var.app_location
      api_location    = var.api_location
      output_location = var.output_location
    }
  )
  commit_message      = "Add workflow (by Terraform)"
  commit_author       = "Armando Tovar"
  commit_email        = "tovi61xd@gmail.com"
  overwrite_on_create = true

  depends_on = [
    github_actions_variable.vite_api_url,
    github_actions_variable.vite_msal_client_id,  
    github_actions_variable.vite_msal_tenant_id,
    github_actions_variable.vite_msal_redirect_uri,
    github_actions_variable.vite_msal_scope,
    github_actions_secret.publishprofile
  ]
}
