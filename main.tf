resource "azurerm_network_security_group" "main" {
  name = var.nsg_name

  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}


resource "azurerm_network_security_rule" "main" {
  for_each                    = { for index, v in var.additional_rules : v.name => v }
  name                        = each.value.name
  network_security_group_name = azurerm_network_security_group.main.name
  resource_group_name         = var.resource_group_name

  priority  = each.value.priority
  direction = coalesce(each.value.direction, "Inbound")
  access    = coalesce(each.value.access, "Allow")
  protocol  = coalesce(each.value.protocol, "Tcp")

  source_port_range  = each.value.source_port_range
  source_port_ranges = each.value.source_port_ranges

  destination_port_range  = each.value.destination_port_range
  destination_port_ranges = each.value.destination_port_ranges

  source_address_prefix   = each.value.source_address_prefix
  source_address_prefixes = each.value.source_address_prefixes

  destination_address_prefix   = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
}

resource "azurerm_network_security_rule" "http_inbound" {
  for_each                    = var.http_inbound_allowed ? { http = true } : {}
  name                        = "http-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4000
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = try(tostring(var.http_source_allowed), null)
  source_address_prefixes     = try(tolist(var.http_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "https_inbound" {
  for_each                    = var.https_inbound_allowed ? { https = true } : {}
  name                        = "https-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4001
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = try(tostring(var.https_source_allowed), null)
  source_address_prefixes     = try(tolist(var.https_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "ssh_inbound" {
  for_each                    = var.ssh_inbound_allowed ? { ssh = true } : {}
  name                        = "ssh-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4002
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = try(tostring(var.ssh_source_allowed), null)
  source_address_prefixes     = try(tolist(var.ssh_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "rdp_inbound" {
  for_each                    = var.rdp_inbound_allowed ? { rdp = true } : {}
  name                        = "rdp-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4003
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = try(tostring(var.rdp_source_allowed), null)
  source_address_prefixes     = try(tolist(var.rdp_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "winrm_inbound" {
  for_each                    = var.winrm_inbound_allowed ? { winrm = true } : {}
  name                        = "winrm-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4004
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5986"
  source_address_prefix       = try(tostring(var.winrm_source_allowed), null)
  source_address_prefixes     = try(tolist(var.winrm_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "appgw_health_probe_inbound" {
  for_each                    = var.application_gateway_rules_enabled ? { appgw = true } : {}
  name                        = "appgw-health-probe-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4005
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["65200-65535"]
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"

  lifecycle {
    precondition {
      condition     = !var.all_inbound_denied
      error_message = "You can't use `all_inbound_denied` with `application_gateway_rules_enabled`."
    }
  }
}

resource "azurerm_network_security_rule" "lb_health_probe_inbound" {
  for_each                    = (var.application_gateway_rules_enabled || var.load_balancer_rules_enabled) ? { lb = true } : {}
  name                        = "lb-health-probe-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4006
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "nfs_inbound" {
  for_each                    = var.nfs_inbound_allowed ? { nfs = true } : {}
  name                        = "nfs-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4007
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "2049"
  source_address_prefix       = try(tostring(var.nfs_source_allowed), null)
  source_address_prefixes     = try(tolist(var.nfs_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}

resource "azurerm_network_security_rule" "cifs_inbound" {
  for_each                    = var.cifs_inbound_allowed ? { cifs = true } : {}
  name                        = "cifs-inbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 4008
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["137", "138", "139", "445"]
  source_address_prefix       = try(tostring(var.cifs_source_allowed), null)
  source_address_prefixes     = try(tolist(var.cifs_source_allowed), null)
  destination_address_prefix  = "VirtualNetwork"
}
