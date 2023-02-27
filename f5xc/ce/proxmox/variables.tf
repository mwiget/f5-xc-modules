variable "f5xc_tenant" {}
variable "f5xc_api_url" {}
variable "f5xc_api_ca_cert" {}
variable "f5xc_namespace" {}
variable "f5xc_api_token" {}

variable "pm_api_url" {}
variable "pm_api_token_id" {}
variable "pm_api_token_secret" {}
variable "pve_host" {}
variable "pve_user" {}
variable "pve_private_key" {}
variable "pm_pool" {}
variable "pm_clone" {}
variable "pm_storage" {
  type = string
  default = "local"
}
variable "nodes" {
  type = list(object({
    name      = string
    datastore = string
    ipaddress = string
    node      = string
  }))
}

variable "outside_network" {
  type = string
  default = "vmbr0"
}
variable "inside_network" {
  type = string
  default = ""
}
variable "publicdefaultgateway" {}
variable "dnsservers" {}
variable "cpus" {}
variable "memory" {}
variable "f5xc_reg_url" {
  type    = string
  default = "ves.volterra.io"
}

variable "certifiedhardware" {}
variable "publicdefaultroute" {}
variable "cluster_name" {}
variable "guest_type" {}
variable "sitelatitude" {}
variable "sitelongitude" {}
variable "custom_labels" {
  type  = map(string)
  default = {}
}
variable "outside_vip" {
  type = string
  default = ""
}
variable "admin_password" {
  type = string
  default = ""
  description = "admin shell password, needs at least one uppercase letter"
}
