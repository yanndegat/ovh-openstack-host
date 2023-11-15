variable "name" {
  description = "name of the deployment (used for resources names)"
  type        = string
  default     = "opencopilot-test"
}

variable "region_name" {
  description = "Openstack region name"
  type        = string
}

variable "flavor_name" {
  description = "Flavor name"
  type        = string
}

variable "image_name" {
  description = "Image name to retrieve "
  type        = string
  default     = "Debian 12"
}

variable "ssh_user" {
  type        = string
  description = "user to ssh into the vm"
  default     = "debian"
}


variable "dns_nameservers" {
  type        = set(string)
  description = "DNS nameservers"
  default     = ["1.1.1.1"]
}

variable "allowed_prefixes" {
  description = "Allowed ingress prefixes"
  type        = set(string)
  default     = ["109.190.254.0/24"]
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "ext_net_name" {
  description = "Name of public openstack network"
  type        = string
  default     = "Ext-Net"
}
