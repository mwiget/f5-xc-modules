variable "certified_hardware_endpoint" {
  type    = string
  default = "https://vesio.blob.core.windows.net/releases/certified-hardware/aws.yml"
}

variable "reboot_strategy_master" {
  type    = string
  default = "off"
}

variable "reboot_strategy_pool" {
  type    = string
  default = "off"
}

variable "bootstrap_token_id" {
  type    = string
  default = ""
}

variable "bootstrap_token_secret" {
  type    = string
  default = ""
}

variable "etcd_initial_token" {
  type    = string
  default = "68c11f9e8d0c61a56a7ad46667294fe3"
}

variable "public_address" {
  type    = string
  default = "10.0.0.1"
}

variable "public_name" {
  type    = string
  default = "lb.example.local"
}

variable "container_images" {
  type    = map(string)
  default = {
    "Hyperkube" = ""
    "CoreDNS"   = ""
    "Etcd"      = ""
  }
}

variable "service_cidr" {
  type    = string
  default = "10.3.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.3.0.10"
}

variable "cluster_cidr" {
  type    = string
  default = "10.8.0.0/16"
}

variable "cluster_latitude" {
  type = string
}

variable "cluster_longitude" {
  type = string
}

variable "cluster_workload" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "private_default_gw" {
  type    = string
  default = ""
}

variable "private_vn_prefix" {
  type    = string
  default = ""
}

variable "cluster_token" {
  type    = string
  default = ""
}

variable "cluster_labels" {
  type    = string
  default = "{}"
}

variable "customer_route" {
  type    = string
  default = ""
}

variable "vp_manager_version" {
  type    = string
  default = "latest"
}

variable "vp_manager_type" {
  type    = string
  default = "re"
}

variable "vp_manager_skip_stages" {
  type        = list(string)
  default     = ["register"]
  description = "List of VP manager stages to skip"
}

variable "vp_manager_mask_fetch_latest" {
  type    = string
  default = "true"
}

variable "maurice_endpoint" {
  type    = string
  default = "https://register.ves.volterra.io"
}

variable "maurice_mtls_endpoint" {
  type    = string
  default = "https://register-tls.ves.volterra.io"
}

variable "sre_dns_service_ip" {
  type    = string
  default = ""
}

variable "cluster_uid" {
  type    = string
  default = ""
}

variable "cluster_members" {
  type        = list(string)
  default     = ["master-0", "master-1", "master-2"]
  description = "local resolvable name of the k8s cluster nodes"
}

variable "master_count" {
  type        = number
  default     = 1
  description = "master_count shall correspond with cluster_members"
}

variable "ssh_public_key" {
  type    = string
}

variable "ntp_servers" {
  type    = string
  default = "pool.ntp.org"
}

variable "private_nic" {
  type    = string
  default = ""
}

variable "public_nic" {
  type    = string
  default = ""
}

variable "f5xc_ce_gateway_type_ingress" {
  type = string
}

variable "f5xc_ce_gateway_type_ingress_egress" {
  type = string
}

variable "f5xc_ce_gateway_type" {
  type = string
}

variable "templates_dir" {
  type    = string
  default = "templates"
}