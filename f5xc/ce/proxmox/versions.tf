terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.9.13"
    }
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.18"
    }
  }
}
