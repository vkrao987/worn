resource "azurerm_resource_group" "rg" {
  count=var.instancevalue
  name     = "${var.prefix}-firstresourcename${count.index+1}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  count="${length(var.address)}"
  name                = "${var.prefix}-network${count.index+1}"
  address_space       = var.address
  location            = azurerm_resource_group.rg[count.index].location
  resource_group_name = azurerm_resource_group.rg[count.index].name
}

resource "azurerm_virtual_network" "vnet2" {
  count="${length(var.addresses)}"
  name                = "${var.prefix}-network${count.index+1}"
  address_space       =  var.addresses
  location            = azurerm_resource_group.rg[1].location
  resource_group_name = azurerm_resource_group.rg[1].name
}

resource "azurerm_subnet" "internal" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg[0].name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  address_prefixes     = ["10.0.0.0/16"]
}

resource "azurerm_network_interface" "nic" {
  count = var.instancevalue
  name                = "${var.prefix}-nic${count.index}"
  location            = azurerm_resource_group.rg[0].location
  resource_group_name = azurerm_resource_group.rg[0].name

  ip_configuration {
    name                          = "testconfiguration-${count.index+1}"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  count=var.instancevalue
  name                  = "${var.prefix}-vm${count.index+1}"
  location              = azurerm_resource_group.rg[0].location
  resource_group_name   = azurerm_resource_group.rg[0].name
  network_interface_ids =[element(azurerm_network_interface.nic.*.id,count.index)]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname${count.index}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  
  os_profile_windows_config{
    provision_vm_agent        = true

     }
  tags = {
    environment = "staging"
  }
}