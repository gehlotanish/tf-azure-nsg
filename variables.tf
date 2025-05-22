variable "nsg_name" {
  description = "Name of the Network Security Group."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region for the NSG."
  type        = string
}

variable "tags" {
  description = "Extra tags to add to the NSG."
  type        = map(string)
  default     = {}
}

variable "http_inbound_allowed" {
  description = "Enable HTTP inbound rule."
  type        = bool
  default     = false
}

variable "http_source_allowed" {
  description = "Source address(es) for HTTP rule."
  type        = any
  default     = null
}

variable "https_inbound_allowed" {
  description = "Enable HTTPS inbound rule."
  type        = bool
  default     = false
}

variable "https_source_allowed" {
  description = "Source address(es) for HTTPS rule."
  type        = any
  default     = null
}

variable "ssh_inbound_allowed" {
  description = "Enable SSH inbound rule."
  type        = bool
  default     = false
}

variable "ssh_source_allowed" {
  description = "Source address(es) for SSH rule."
  type        = any
  default     = null
}

variable "rdp_inbound_allowed" {
  description = "Enable RDP inbound rule."
  type        = bool
  default     = false
}

variable "rdp_source_allowed" {
  description = "Source address(es) for RDP rule."
  type        = any
  default     = null
}

variable "winrm_inbound_allowed" {
  description = "Enable WinRM inbound rule."
  type        = bool
  default     = false
}

variable "winrm_source_allowed" {
  description = "Source address(es) for WinRM rule."
  type        = any
  default     = null
}

variable "application_gateway_rules_enabled" {
  description = "Enable App Gateway health probe rule."
  type        = bool
  default     = false
}

variable "load_balancer_rules_enabled" {
  description = "Enable Load Balancer health probe rule."
  type        = bool
  default     = false
}

variable "all_inbound_denied" {
  description = "Flag to deny all inbound, should be false if enabling app gateway rules."
  type        = bool
  default     = false
}

variable "nfs_inbound_allowed" {
  description = "Enable NFS rule."
  type        = bool
  default     = false
}

variable "nfs_source_allowed" {
  description = "Source address(es) for NFS rule."
  type        = any
  default     = null
}

variable "cifs_inbound_allowed" {
  description = "Enable CIFS rule."
  type        = bool
  default     = false
}

variable "cifs_source_allowed" {
  description = "Source address(es) for CIFS rule."
  type        = any
  default     = null
}

variable "additional_rules" {
  description = "List of additional NSG rules."
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = optional(string)
    access                       = optional(string)
    protocol                     = optional(string)
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = []
}
