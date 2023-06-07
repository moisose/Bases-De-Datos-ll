output "container_outbound_ip_addresses" {
  value = azurerm_container_app.main.outbound_ip_addresses
}

output "container_fqdn" {
  value = azurerm_container_app.main.ingress[*].fqdn
}

output "container_services_ip_addresses_outbound" {
  value = azurerm_linux_web_app.main.outbound_ip_address_list
}

output "container_services_fqdn" {
  value = azurerm_linux_web_app.main.default_hostname
}


