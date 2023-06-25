variable "name" {
  default = "osticket"
  type    = string
}

variable "location" {
  default = "eastus2"
  type    = string
}

variable "network" {
  default = {
    address_spaces  = ["10.0.0.0/16"]
    subnet_prefixes = ["10.0.0.0/24", "10.0.1.0/24"]
    subnet_names    = ["subnet-web", "subnet-db"]
  }
}

variable "nsg" {
  default = [
    {
      name                  = "nsg-web"
      subnet_name           = "subnet-web"
      source_address_prefix = ["*"]
      predefined_rules = [
        {
          name     = "SSH"
          priority = "500"
        },
        {
          name     = "HTTP"
          priority = "510"
        },
        {
          name     = "HTTPS"
          priority = "520"
        }
      ]
      custom_rules = [
        {
          name                   = "block-inbound"
          priority               = 4096
          direction              = "Inbound"
          access                 = "Deny"
          protocol               = "*"
          source_port_range      = "*"
          destination_port_range = "*"
          source_address_prefix  = "*"
          description            = "Block all Inbound Traffic"
        }
      ]
    },
    {
      name                  = "nsg-db"
      subnet_name           = "subnet-db"
      source_address_prefix = ["*"]
      predefined_rules = [
        {
          name     = "SSH"
          priority = "500"
        }
      ]
      custom_rules = [
        {
          name                       = "allow-mysql"
          priority                   = 490
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3306"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
          description                = "Allow mysql"
        },
        {
          name                   = "block-inbound"
          priority               = 4096
          direction              = "Inbound"
          access                 = "Deny"
          protocol               = "*"
          source_port_range      = "*"
          destination_port_range = "*"
          source_address_prefix  = "*"
          description            = "Block all Inbound Traffic"
        }
      ]
    }
  ]
}

variable "db_vm" {
  default = {
    username           = "adminuser"
    subnet_name        = "subnet-db"
    private_ip_address = "10.0.1.10"
    size               = "Standard_B1s"
    image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }
  }
}