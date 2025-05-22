# Azure NSG

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.27.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.27.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_rules"></a> [additional\_rules](#input\_additional\_rules) | List of additional NSG rules. | <pre>list(object({<br/>    name                         = string<br/>    priority                     = number<br/>    direction                    = optional(string)<br/>    access                       = optional(string)<br/>    protocol                     = optional(string)<br/>    source_port_range            = optional(string)<br/>    source_port_ranges           = optional(list(string))<br/>    destination_port_range       = optional(string)<br/>    destination_port_ranges      = optional(list(string))<br/>    source_address_prefix        = optional(string)<br/>    source_address_prefixes      = optional(list(string))<br/>    destination_address_prefix   = optional(string)<br/>    destination_address_prefixes = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_all_inbound_denied"></a> [all\_inbound\_denied](#input\_all\_inbound\_denied) | Flag to deny all inbound, should be false if enabling app gateway rules. | `bool` | `false` | no |
| <a name="input_application_gateway_rules_enabled"></a> [application\_gateway\_rules\_enabled](#input\_application\_gateway\_rules\_enabled) | Enable App Gateway health probe rule. | `bool` | `false` | no |
| <a name="input_cifs_inbound_allowed"></a> [cifs\_inbound\_allowed](#input\_cifs\_inbound\_allowed) | Enable CIFS rule. | `bool` | `false` | no |
| <a name="input_cifs_source_allowed"></a> [cifs\_source\_allowed](#input\_cifs\_source\_allowed) | Source address(es) for CIFS rule. | `any` | `null` | no |
| <a name="input_http_inbound_allowed"></a> [http\_inbound\_allowed](#input\_http\_inbound\_allowed) | Enable HTTP inbound rule. | `bool` | `false` | no |
| <a name="input_http_source_allowed"></a> [http\_source\_allowed](#input\_http\_source\_allowed) | Source address(es) for HTTP rule. | `any` | `null` | no |
| <a name="input_https_inbound_allowed"></a> [https\_inbound\_allowed](#input\_https\_inbound\_allowed) | Enable HTTPS inbound rule. | `bool` | `false` | no |
| <a name="input_https_source_allowed"></a> [https\_source\_allowed](#input\_https\_source\_allowed) | Source address(es) for HTTPS rule. | `any` | `null` | no |
| <a name="input_load_balancer_rules_enabled"></a> [load\_balancer\_rules\_enabled](#input\_load\_balancer\_rules\_enabled) | Enable Load Balancer health probe rule. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the NSG. | `string` | n/a | yes |
| <a name="input_nfs_inbound_allowed"></a> [nfs\_inbound\_allowed](#input\_nfs\_inbound\_allowed) | Enable NFS rule. | `bool` | `false` | no |
| <a name="input_nfs_source_allowed"></a> [nfs\_source\_allowed](#input\_nfs\_source\_allowed) | Source address(es) for NFS rule. | `any` | `null` | no |
| <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name) | Name of the Network Security Group. | `string` | n/a | yes |
| <a name="input_rdp_inbound_allowed"></a> [rdp\_inbound\_allowed](#input\_rdp\_inbound\_allowed) | Enable RDP inbound rule. | `bool` | `false` | no |
| <a name="input_rdp_source_allowed"></a> [rdp\_source\_allowed](#input\_rdp\_source\_allowed) | Source address(es) for RDP rule. | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Resource Group. | `string` | n/a | yes |
| <a name="input_ssh_inbound_allowed"></a> [ssh\_inbound\_allowed](#input\_ssh\_inbound\_allowed) | Enable SSH inbound rule. | `bool` | `false` | no |
| <a name="input_ssh_source_allowed"></a> [ssh\_source\_allowed](#input\_ssh\_source\_allowed) | Source address(es) for SSH rule. | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Extra tags to add to the NSG. | `map(string)` | `{}` | no |
| <a name="input_winrm_inbound_allowed"></a> [winrm\_inbound\_allowed](#input\_winrm\_inbound\_allowed) | Enable WinRM inbound rule. | `bool` | `false` | no |
| <a name="input_winrm_source_allowed"></a> [winrm\_source\_allowed](#input\_winrm\_source\_allowed) | Source address(es) for WinRM rule. | `any` | `null` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_id"></a> [nsg\_id](#output\_nsg\_id) | The ID of the Network Security Group. |
| <a name="output_nsg_name"></a> [nsg\_name](#output\_nsg\_name) | The name of the Network Security Group. |
<!-- END_TF_DOCS -->

## Usage

```tf

nsg_name              = "my-nsg"
resource_group_name   = "my-resource-group"
location              = "eastus"

default_tags = {
  environment = "dev"
  project     = "example-project"
}

extra_tags = {
  owner = "devops-team"
}

http_inbound_allowed  = true
http_source_allowed   = ["10.0.0.0/24"]

https_inbound_allowed = true
https_source_allowed  = ["10.0.1.0/24"]

ssh_inbound_allowed   = true
ssh_source_allowed    = ["203.0.113.10"]

rdp_inbound_allowed   = false
rdp_source_allowed    = null

winrm_inbound_allowed = false
winrm_source_allowed  = null

application_gateway_rules_enabled = true
load_balancer_rules_enabled       = true
all_inbound_denied                = false

nfs_inbound_allowed  = true
nfs_source_allowed   = ["10.0.2.0/24"]

cifs_inbound_allowed = false
cifs_source_allowed  = null

additional_rules = [
  {
    name                        = "custom-rule-1"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8080"
    source_address_prefix       = "10.0.3.0/24"
    destination_address_prefix  = "VirtualNetwork"
  },
  {
    name                        = "custom-rule-2"
    priority                    = 102
    direction                   = "Outbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
]

```