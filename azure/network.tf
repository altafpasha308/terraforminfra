resource "azurerm_virtual_network" "main" {
  name                = "main-vnet"
  address_space       = ["172.0.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}


# Public Subnets
resource "azurerm_subnet" "public_1" {
  name                 = "public-subnet-1"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.0.1.0/24"]
}

resource "azurerm_subnet" "public_2" {
  name                 = "public-subnet-2"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.0.2.0/24"]
}

# Private Subnets
resource "azurerm_subnet" "private_1" {
  name                 = "private-subnet-1"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.0.11.0/24"]
}

resource "azurerm_subnet" "private_2" {
  name                 = "private-subnet-2"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["172.0.12.0/24"]
}

resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-traffic-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG to Public Subnet1
resource "azurerm_subnet_network_security_group_association" "pub_1_assoc" {
  subnet_id                 = azurerm_subnet.public_1.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Associate NSG to Public Subnet2
resource "azurerm_subnet_network_security_group_association" "pub_2_assoc" {
  subnet_id                 = azurerm_subnet.public_2.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
