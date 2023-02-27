resource "proxmox_vm_qemu" "vm" {
  depends_on        = [ null_resource.cloud_init_config_files ]
  for_each          = {for k,v in var.nodes: k => v}
  name              = format("%s-%s", var.cluster_name, each.value.name)
  target_node       = each.value.node
  clone             = var.pm_clone
  pool              = var.pm_pool

  cores             = var.cpus
  sockets           = 1
  memory            = var.memory
  network {
    bridge            = var.outside_network
    model             = "virtio"
  }
  os_type           = "cloud-init"
  cicustom          = "user=local:snippets/user_data_${var.cluster_name}_${each.key}.yml"
  cloudinit_cdrom_storage = "local-lvm"
  disk {
    storage           = var.pm_storage
    size              = "50G"
    type              = "virtio"
  }

  #  datastore_id     = data.vsphere_datastore.ds[each.key].id
  #  host_system_id   = data.vsphere_host.host[each.key].id
  #
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

}

resource "volterra_token" "token" {
  name = format("%s-token", var.cluster_name)
  namespace = "system"
}

module "site_wait_for_online" {
  depends_on     = [volterra_registration_approval.ce]
  source         = "../../status/site"
  f5xc_namespace = "system"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_site_name = var.cluster_name
  f5xc_tenant    = var.f5xc_tenant
}

resource "volterra_registration_approval" "ce" {
  for_each      = {for k,v in var.nodes: k => v}
  depends_on    = [proxmox_vm_qemu.vm[0]]
  cluster_name  = var.cluster_name
  hostname      = each.value.name
  cluster_size  = length(var.nodes)
  retry = 25
  wait_time = 30
}

resource "volterra_site_state" "decommission_when_delete" {
  name       = var.cluster_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = 60
  retry      = 5
  depends_on = [volterra_registration_approval.ce]
}

resource "volterra_modify_site" "site" {
  namespace               = "system"
  name                    = var.cluster_name
  labels                  = var.custom_labels
  outside_vip             = var.outside_vip
  vip_vrrp_mode           = var.outside_vip == "" ? "VIP_VRRP_DISABLE" : "VIP_VRRP_ENABLE"
  site_to_site_tunnel_ip  = var.outside_vip == "" ? split("/",var.nodes[0]["ipaddress"])[0] : var.outside_vip
  depends_on              = [volterra_registration_approval.ce]
}

output "vm" {
  value = proxmox_vm_qemu.vm
}
