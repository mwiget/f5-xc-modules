resource "azurerm_public_ip" "ip" {
  count               = create_public_ip == true ? 1 : 0
  name                = var.azure_virtual_machine_name
  resource_group_name = var.azure_resource_group_name
  location            = var.azure_region
  zones               = var.azure_zones
  allocation_method   = var.azure_virtual_machine_allocation_method
  sku                 = var.azure_virtual_machine_sku
  tags                = var.custom_tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = var.azure_network_interface_name
  location            = var.azure_region
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = var.azure_network_interface_ip_cfg_name
    subnet_id                     = var.azure_vnet_subnet_id
    public_ip_address_id          = create_public_ip == true ? azurerm_public_ip.ip.id : null
    private_ip_address_allocation = var.azure_network_interface_private_ip_address_allocation
  }
  tags = var.custom_tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.azure_virtual_machine_name
  location              = var.azure_region
  zone                  = var.azure_zone
  size                  = var.azure_virtual_machine_size
  resource_group_name   = var.azure_resource_group_name
  network_interface_ids = [azurerm_network_interface.network_interface.id]

  os_disk {
    name                 = var.azure_virtual_machine_name
    caching              = var.azure_linux_virtual_machine_os_disk_caching
    storage_account_type = var.azure_linux_virtual_machine_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.azure_linux_virtual_machine_source_image_reference_publisher
    offer     = var.azure_linux_virtual_machine_source_image_reference_offer
    sku       = var.azure_linux_virtual_machine_source_image_reference_sku
    version   = var.azure_linux_virtual_machine_source_image_reference_version
  }

  computer_name                   = var.azure_virtual_machine_name
  admin_username                  = var.azure_linux_virtual_machine_admin_username
  disable_password_authentication = var.azure_linux_virtual_machine_disable_password_authentication

  admin_ssh_key {
    username   = var.azure_linux_virtual_machine_admin_username
    public_key = var.public_ssh_key
  }
  tags        = var.custom_tags
  custom_data = var.azure_linux_virtual_machine_custom_data != "" ? var.azure_linux_virtual_machine_custom_data : null
}