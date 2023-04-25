variable "f5xc_ce_gateway_type_ingress" {
  type    = string
  default = "ingress_gateway"
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type    = string
  default = "ingress_egress_gateway"
}

variable "f5xc_ce_gateway_type" {
  type = string
  validation {
    condition     = contains(["ingress_egress_gateway", "ingress_gateway"], var.f5xc_ce_gateway_type)
    error_message = format("Valid values for gateway_type: ingress_egress_gateway, ingress_gateway")
  }
}

variable "f5xc_site_type_azure" {
  type    = string
  default = "azure"
}

variable "f5xc_site_type_gcp" {
  type    = string
  default = "gcp"
}

variable "f5xc_site_type_aws" {
  type    = string
  default = "aws"
}

variable "f5xc_site_type_vsphere" {
  type    = string
  default = "vmware"
}

variable "f5xc_site_type" {
  type = string
  validation {
    condition = contains(["vsphere", "aws", "gcp", "azure"], var.f5xc_site_type)
  }
}

variable "f5xc_secure_mesh_site_nodes" {
  type = map(map(string))
  validation {
    condition     = length(var.f5xc_secure_mesh_site_nodes) == 1 || length(var.f5xc_secure_mesh_site_nodes) == 3
    error_message = "f5xc_secure_mesh_site_nodes must be 1 or 3"
  }
}

variable "f5xc_site_type_certified_hw" {
  type    = map(string)
  default = {
    "aws"     = "aws-voltmesh"
    "gcp"     = "gcp-voltmesh"
    "azure"   = "azure-voltmesh"
    "vsphere" = "vmware-voltmesh"
  }
}

variable "f5xc_cluster_labels" {
  type = map(string)
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_site_name" {
  type = string
}

variable "f5xc_site_latitude" {
  type    = number
  default = 0
}

variable "f5xc_site_longitude" {
  type    = number
  default = 0
}