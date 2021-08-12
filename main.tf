terraform {
required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}
 
provider "azurerm" {
features {}
}
 
resource "azurerm_resource_group" "rg"{
    name = "demo08"
    location = "northeurope"
}
 
 
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 
 
  security_rule {
    name                       = "Allow-HTTPS"
    description                = "Allow HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
 
  security_rule {
    name                       = "Allow-HTTP"
    description                = "Allow HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
 
 
 
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-dco-ne-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["20.0.0.0/16"]
 
 
  subnet {
    name           = "subnet1"
    address_prefix = "20.0.0.0/24"
  }
 
  subnet {
    name           = "subnet2"
    address_prefix = "20.0.1.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }
}

