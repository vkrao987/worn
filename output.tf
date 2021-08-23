/*output "out1" {
  value = "${index(var.address,"10.0.0.0/16")}"
}

output "out2" {
  value = "${index(var.address,"10.1.0.0/24")}"
}

output "fin" {
  value = element(var.address,1)
}

output "vnet1" {
  value = azurerm_virtual_network.vnet[1].name
  
}*/

output "nic1"{
  value=azurerm_network_interface.nic.*.id
  
}
