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

variable "asg" {
  default = [
    "public-ssh",
    "public-http",
    "public-https",
    "private-mysql"
  ]
}

variable "nsg" {
  default = [
    {
      name                  = "nsg-web"
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
    }
  ]
}