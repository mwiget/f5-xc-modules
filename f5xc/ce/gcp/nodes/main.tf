resource "google_compute_instance_template" "instance_template" {
  tags         = var.instance_tags
  name_prefix  = format("%s-", var.f5xc_cluster_name)
  labels       = var.f5xc_cluster_labels
  description  = var.instance_template_description
  machine_type = var.instance_type

  disk {
    auto_delete  = true
    device_name  = var.f5xc_cluster_name
    disk_size_gb = var.instance_disk_size
    source_image = var.instance_image
  }

  network_interface {
    subnetwork = var.slo_subnetwork
    dynamic "access_config" {
      for_each = var.has_public_ip ? [1] : []
      content {
        nat_ip = var.access_config_nat_ip != "" ? var.access_config_nat_ip : null
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? [1] : []
    content {
      subnetwork = var.sli_subnetwork
    }
  }

  metadata = {
    ssh-keys     = "${var.ssh_username}:${var.ssh_public_key}"
    user-data    = var.f5xc_ce_user_data
    VmDnsSetting = "ZonalPreferred"
  }

  service_account {
    email  = var.gcp_service_account_email != "" ? var.gcp_service_account_email : null
    scopes = var.gcp_service_account_scopes
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = all
  }

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name                      = var.f5xc_cluster_name
  region                    = var.gcp_region
  description               = var.instance_group_manager_description
  target_size               = var.f5xc_cluster_size
  base_instance_name        = var.f5xc_cluster_name
  wait_for_instances        = var.instance_group_manager_wait_for_instances
  wait_for_instances_status = "STABLE"
  distribution_policy_zones = var.instance_group_manager_distribution_policy_zones

  version {
    instance_template = google_compute_instance_template.instance_template.id
  }

  stateful_disk {
    device_name = var.f5xc_cluster_name
    delete_rule = "ON_PERMANENT_INSTANCE_DELETION"
  }

  update_policy {
    type                         = "OPPORTUNISTIC"
    minimal_action               = "RESTART"
    max_surge_fixed              = var.f5xc_cluster_size
    max_unavailable_fixed        = var.f5xc_cluster_size
    instance_redistribution_type = "NONE"
  }
}

module "wait" {
  source         = "../../../../utils/timeout"
  depend_on      = "google_compute_region_instance_group_manager.instance_group_manager"
  create_timeout = "1m"
  delete_timeout = "1m"
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [module.wait]
  # depends_on   = [google_compute_region_instance_group_manager.instance_group_manager]
  for_each     = {for k, v in data.google_compute_instance.instances : k => v.name if data.google_compute_instance.instances[k].name != null}
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
  hostname     = each.value
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_cluster_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}