# main.tf

provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_resource_group" "rg" {
  name     = "apim-rg"
  location = "East US"
}

module "apim" {
  source              = "./modules/apim"
  name                = "<your name here>"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Star Wars API"
  publisher_email     = "info@swapi.dev"
  sku_name            = "Consumption_0"
  api_display_name    = "Star Wars API"
  api_path            = "swapi"  
}

