# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "az-jaf-demo-rg" {
  name     = "az-jaf-demo-rg"
  location = "Southeast Asia"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "az-jaf-demo-vnet" {
  name                = "az-jaf-demo-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/23"] # 2 subnets 
}

# Create a network security group 
resource "azure_security_group" "az-jaf-demo-nsg" {
  name     = "az-jaf-demo-nsg"
  location = "Southeast Asia"
}

# Create a network security group rule
resource "azure_security_group_rule" "ssh_access" {
  name                       = "ssh-access-rule"
  security_group_names       = ["${azure_security_group.az-jaf-demo-nsg.name}"]
  type                       = "Inbound"
  action                     = "Allow"
  priority                   = 200
  source_address_prefix      = "0.0.0.0" # your IP address 
  source_port_range          = "*"
  destination_address_prefix = "10.0.0.0/32"
  destination_port_range     = "22"
  protocol                   = "TCP"
}

