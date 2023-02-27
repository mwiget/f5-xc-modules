resource "local_file" "cloud_init_user_data_file" {
  for_each = {for k,v in var.nodes: k => v}
  content  = templatefile("${path.module}/templates/user_data.tpl", {
    cluster-name = var.cluster_name
    host-name = each.value.name
    latitude = var.sitelatitude
    longitude = var.sitelongitude
    xc-environment-api-endpoint = var.f5xc_reg_url
    site-registration-token = volterra_token.token.id
  })
  filename = "${path.module}/files/user_data_${var.cluster_name}_${each.key}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  for_each = {for k,v in var.nodes: k => v}
  connection {
    type     = "ssh"
    user     = var.pve_user
    #    password = var.pve_password
    private_key = var.pve_private_key
    host     = var.pve_host
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[each.key].filename
    destination = "/var/lib/vz/snippets/user_data_${var.cluster_name}_${each.key}.yml"
  }
}

