resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}"
  address_space       = var.network.address_spaces
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  count                = length(var.network.subnet_prefixes)
  name                 = var.network.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.network.subnet_prefixes[count.index]]
}

module "network-security-group" {
  source                = "Azure/network-security-group/azurerm"
  version               = "4.1.0"
  count                 = length(var.nsg)
  resource_group_name   = azurerm_resource_group.this.name
  security_group_name   = var.nsg[count.index].name
  source_address_prefix = var.nsg[count.index].source_address_prefix
  predefined_rules      = var.nsg[count.index].predefined_rules

  custom_rules = var.nsg[count.index].custom_rules

  tags = {}

  depends_on = [azurerm_resource_group.this]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = length(var.nsg)
  subnet_id                 = azurerm_subnet.this[index(var.network.subnet_names, var.nsg[count.index].subnet_name)].id
  network_security_group_id = module.network-security-group[count.index].network_security_group_id
}