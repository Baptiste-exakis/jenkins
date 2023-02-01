resource "azurerm_virtual_machine" "jenkins" {
  name                  = "jenkins-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
    version   = "latest"
  }
  storage_os_disk {
    name              = "jenkins-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "jenkins"
    admin_username = "Baptiste"
    custom_data = data.template_cloudinit_config.config_jenkins.rendered
  }

  os_profile_linux_config {
    ssh_keys {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCTwIU18gQQbE9Inblg52+IEwSXb84RgFoVbR5Sm3y25JfI/fFdP7ylHeu2tJadVEqvOdK6PaHMeJqNd+adDpHXPnhVYoNhO8qxh/z+CblyZk7Gleztk11YtzCTx62LDCk5O4PI+qOC8sOT7gADt9zJk21jjqITH4dlaWBQNS01ve2mOuOLjmUSe1T4ndK6OXHeObIiC8PNEnnBcMwUqzfnZWTY5WOBibkJx8/vMH4SV00IdGVooPneyn6yD2YgoigGEUMr1Deb1+sAxxXt/xTfuQIRCcZ+AWI0Q1zlF5UwgIPnul03YBcEMygdU/9Y0cWqFW/Nug1S4uCRI2ld5wd9 rsa-key-20230201"
      path = "/home/Baptiste/.ssh/authorized_keys"
    }
    disable_password_authentication = true
  }
  tags = {
    environment = "staging"
  }
}
