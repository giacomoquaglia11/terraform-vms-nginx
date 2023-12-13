locals {
  vnet_cidr = ["10.0.0.0/16"]
  subnet_cidr_1 = ["10.0.1.0/24"]
  vms_names = ["VM 01", "VM 02"]
  computer_name = "QuagliaVM"
  admin_username = "quagliagiacomo"
  admin_password = "QuagliaGiacomo01"
}
resource "azurerm_virtual_network" "vnet" {
  name = "${var.name_prefix}-vnet"
  address_space = local.vnet_cidr
  location = var.region
  resource_group_name = var.resource_group_name
}
resource "azurerm_subnet" "subnet" {
  name = "${var.name_prefix}-subnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = local.subnet_cidr_1
}
resource "azurerm_public_ip" "public_ip" {

  count = length(local.vms_names)

  name = "${var.name_prefix}-pip-${count.index + 1}"
  location = var.region
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
}
resource "azurerm_network_security_group" "nsg" {

  count = length(local.vms_names)

  name = "${var.name_prefix}-nsg-${count.index + 1}"
  location = var.region
  resource_group_name = var.resource_group_name

  security_rule {
    name = "AllowDelta"
    priority = 120
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "nic" {
  
  count = length(local.vms_names)

  name = "${var.name_prefix}-nic-${count.index + 1}"
  location = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "myNicConfiguration"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.public_ip.*.id, count.index)
  }
}
resource "azurerm_network_interface_security_group_association" "association" {  
  
  count = length(local.vms_names)
  
  network_interface_id = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
}
resource "azurerm_linux_virtual_machine" "linuxvm" {

  count = length(local.vms_names)

  name = "${var.name_prefix}-vm-${count.index + 1}"
  location = var.region
  resource_group_name = var.resource_group_name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  size = "Standard_B1s"
  computer_name = "VM-${count.index + 1}"
  admin_username = local.admin_username
  admin_password = local.admin_password
  disable_password_authentication = false

  os_disk {
    name = "osdisk-${count.index + 1}"
    caching = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-focal"
    sku = "20_04-lts"
    version = "latest"
  }
  provisioner "file"{
    source = "startup.sh"
    destination = "/tmp/startup.sh"
    connection {
      type = "ssh"
      user = local.admin_username
      password = local.admin_password
      host = element(azurerm_public_ip.public_ip.*.ip_address, count.index)
    }
  }
  provisioner "remote-exec" {
      inline = [
      "chmod +x /tmp/startup.sh",
      "sudo /tmp/startup.sh '${element(local.vms_names, count.index)}'",
    ]
    connection {
      type = "ssh"
      host = element(azurerm_public_ip.public_ip.*.ip_address, count.index)
      user = local.admin_username
      password = local.admin_password
    }
  }
}
output "vm_ips" {
  value = azurerm_public_ip.public_ip.*.ip_address
}
