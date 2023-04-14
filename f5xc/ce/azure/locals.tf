locals {
  is_multi_nic              = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  is_multi_node             = length(var.f5xc_azure_az_nodes) == 3 ? true : false
  f5xc_ip_ranges_americas   = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP)
  f5xc_ip_ranges_europe     = setunion(var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP)
  f5xc_ip_ranges_asia       = setunion(var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_ip_ranges_all        = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP, var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP, var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_azure_resource_group = var.f5xc_existing_azure_resource_group != "" ? var.f5xc_existing_azure_resource_group : azurerm_resource_group.rg[0].id
  common_tags               = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
  }

  azure_security_group_rules_slo_egress_secure_ce = [
    {
      from_port   = "-1"
      to_port     = "-1"
      ip_protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "4500"
      to_port     = "4500"
      ip_protocol = "udp"
      cidr_blocks = local.f5xc_ip_ranges_all
    },
    {
      from_port   = "123"
      to_port     = "123"
      ip_protocol = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "443"
      to_port     = "443"
      ip_protocol = "tcp"
      cidr_blocks = local.f5xc_ip_ranges_all
    }
  ]


  aws_security_group_rules_slo_ingress_secure_ce = [
    {
      from_port   = "4500"
      to_port     = "4500"
      ip_protocol = "udp"
      cidr_blocks = local.f5xc_ip_ranges_all
    },
    {
      from_port   = "22"
      to_port     = "22"
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  aws_security_group_rules_sli_egress_secure_ce = [
    {
      from_port   = "-1"
      to_port     = "-1"
      ip_protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "22"
      to_port     = "22"
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  aws_security_group_rules_sli_ingress_secure_ce = [
    {
      from_port   = "22"
      to_port     = "22"
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}