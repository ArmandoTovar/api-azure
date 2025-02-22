resource "random_string" "random" {
  length    = 5
  min_lower = 5
  special   = false
}

resource "random_uuid" "scope_1" {}
resource "random_uuid" "scope_2" {}
resource "random_uuid" "role_1" {}
resource "random_uuid" "role_2" {}

data "azuread_client_config" "current" {}


# Crear aplicación client-1
resource "azuread_application" "client-1" {
  display_name = "client-1-${random_string.random.result}"
  owners       = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    requested_access_token_version = 2
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
  }

  single_page_application {
    redirect_uris = ["https://${var.static_web_app_url}/"]
  }
  depends_on = [
     var.static_web_app_url
  ]
}

# Crear aplicación resource-server-1
resource "azuread_application" "resource-server-1" {
  display_name      = "resource-server-1-${random_string.random.result}"
  identifier_uris   = ["api://api-todo"]
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Scope 1"
      admin_consent_display_name = "Scope 1"
      enabled                    = true
      id                         = random_uuid.scope_1.result
      type                       = "User"
      value                      = "resource-server-1.scope-1"
    }

    oauth2_permission_scope {
      admin_consent_description  = "Scope 2"
      admin_consent_display_name = "Scope 2"
      enabled                    = true
      id                         = random_uuid.scope_2.result
      type                       = "User"
      value                      = "resource-server-1.scope-2"
    }
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "Role 1"
    display_name         = "Role 1"
    enabled              = true
    id                   = random_uuid.role_1.result
    value                = "resource-server-1-role-1"
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "Role 2"
    display_name         = "Role 2"
    enabled              = true
    id                   = random_uuid.role_2.result
    value                = "resource-server-1-role-2"
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

# Crear Service Principals
resource "azuread_service_principal" "client-1" {
  client_id                    = azuread_application.client-1.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "resource-server-1" {
  client_id                    = azuread_application.resource-server-1.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Crear contraseñas para las aplicaciones
resource "azuread_application_password" "client-1" {
  application_id = azuread_application.client-1.id
}

resource "azuread_application_password" "resource-server-1" {
  application_id = azuread_application.resource-server-1.id
}

# Obtener el dominio de Entra ID
data "azuread_domains" "example" {
  only_initial = true
}

# Crear un usuario de prueba
resource "azuread_user" "user" {
  user_principal_name = "security-${random_string.random.result}@${data.azuread_domains.example.domains.0.domain_name}"
  display_name        = "security"
  password            = "Azure123456@"
}

# Asignar permisos al Service Principal
resource "azuread_service_principal_delegated_permission_grant" "resource-server-1" {
  service_principal_object_id          = azuread_service_principal.client-1.object_id
  resource_service_principal_object_id = azuread_service_principal.resource-server-1.object_id
  claim_values                         = ["resource-server-1.scope-1"]
}
