provider "azurerm" {
  subscription_id = var.account_azure_subscription_id
  client_id = var.account_azure_client_id
  client_secret = var.account_azure_client_secret
  tenant_id = var.account_azure_tenant_id
  features {}
}