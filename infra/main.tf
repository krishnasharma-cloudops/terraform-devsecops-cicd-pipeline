resource "azurerm_resource_group" "demo" {
  name     = "rg-${var.prefix}-cicd-demo"
  location = var.location
  tags     = { Project = "devsecops-cicd-portfolio", ManagedBy = "Terraform" }
}
resource "azurerm_virtual_network" "demo" {
  name                = "vnet-${var.prefix}-cicd-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["10.60.0.0/16"]
  tags                = { Project = "devsecops-cicd-portfolio", ManagedBy = "Terraform" }
}
output "resource_group_name" { value = azurerm_resource_group.demo.name }
output "virtual_network_id" { value = azurerm_virtual_network.demo.id }
