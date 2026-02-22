resource "azurerm_linux_virtual_machine" "web_vm" {
  count               = 2
  name                = "ubuntu-web-${count.index}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_B2als_v2" # Free tier / Cheap eligible
  admin_username      = "azureuser"
  admin_password      = "Thisistraining@123"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.web_nic[count.index].id,
  ]

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
