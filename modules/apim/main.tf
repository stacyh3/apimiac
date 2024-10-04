# modules/apim/main.tf

resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
}

resource "azurerm_api_management_api" "api" {
  name = var.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  revision            = "1"
  display_name        = var.api_display_name
  path                = var.api_path
  protocols           = ["https"]
}

resource "azurerm_api_management_backend" "swapi_backend" {
  name                = "swapi-backend"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  url                 = "https://swapi.dev/api/"
  protocol            = "http"
}

resource "azurerm_api_management_api_operation" "get_people" {
  api_name            = azurerm_api_management_api.api.name
  operation_id        = "getPeople"
  display_name        = "Get People"
  method              = "GET"
  url_template        = "/people"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name

  request {
    query_parameter {
      name     = "id"
      required = false
      type     = "string"
    }
  }

  response {
    status_code  = 200
    description  = "A successful response"
    representation {
      content_type = "application/json"
    }
  }
}

# Apply a policy to set the backend URL
resource "azurerm_api_management_api_operation_policy" "swapi_policy" {
  api_name            = azurerm_api_management_api.api.name
  operation_id        = azurerm_api_management_api_operation.get_people.operation_id
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/backend_policy.xml")
}