# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}

  # you can use az login if you don't want to input your id
  #subscription_id = "xxxxxxxxxxxxxxxxx"
  #tenant_id       = "xxxxxxxxxxxxxxxxx"
}

# Create a resource group
resource "azurerm_resource_group" "az-jaf-demo-rg" {
  name     = "az-jaf-demo-rg"
  location = "Southeast Asia"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "az-jaf-demo-vnet" {
  name                = "az-jaf-demo-vnet"
  resource_group_name = azurerm_resource_group.az-jaf-demo-rg.name
  location            = azurerm_resource_group.az-jaf-demo-rg.location
  address_space       = ["10.0.0.0/23"] # 2 subnets 
}

# Create subnet
resource "azurerm_subnet" "az-jaf-demo-subnet-0" {
  name                 = "myTFSubnet"
  resource_group_name  = azurerm_resource_group.az-jaf-demo-rg.name
  virtual_network_name = azurerm_virtual_network.az-jaf-demo-vnet.name
  address_prefix       = "10.0.0.0/24"
}

# Create public IP
resource "azurerm_public_ip" "az-jaf-demo-rg-ip" {
  name                = "az-jaf-demo-ip"
  location            = azurerm_resource_group.az-jaf-demo-rg.location
  resource_group_name = azurerm_resource_group.az-jaf-demo-rg.name
  allocation_method   = "Static"
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
  destination_address_prefix = "*"
  destination_port_range     = "22"
  protocol                   = "TCP"
}

# Create network interface
resource "azurerm_network_interface" "az-jaf-demo-nic" {
  name                      = "myaz-jaf-demo-nic"
  location                  = azurerm_resource_group.az-jaf-demo-rg.location
  resource_group_name       = azurerm_resource_group.az-jaf-demo-rg.name
  network_security_group_id = azurerm_network_security_group.az-jaf-demo-nsg.id

  ip_configuration {
    name                          = "az-jaf-demo-nic"
    subnet_id                     = azurerm_subnet.az-jaf-demo-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.az-jaf-demo-ip.id
  }
}
