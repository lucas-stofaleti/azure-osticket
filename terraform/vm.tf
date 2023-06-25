### DATABASE ###
resource "azurerm_public_ip" "db" {
  name                = "pip-db"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  allocation_method   = "Static"
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "db" {
  name                = "nic-db"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this[index(var.network.subnet_names, var.db_vm.subnet_name)].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.db_vm.private_ip_address
    public_ip_address_id          = azurerm_public_ip.db.id
  }
}

resource "azurerm_linux_virtual_machine" "db" {
  name                = "vm-db"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  size                = var.db_vm.size
  admin_username      = var.db_vm.username
  network_interface_ids = [
    azurerm_network_interface.db.id,
  ]

  admin_ssh_key {
    username   = var.db_vm.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.db_vm.image.publisher
    offer     = var.db_vm.image.offer
    sku       = var.db_vm.image.sku
    version   = var.db_vm.image.version
  }
}