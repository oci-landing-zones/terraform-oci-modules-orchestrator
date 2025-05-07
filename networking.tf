# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# Core networking
module "oci_lz_network" {
  depends_on              = [module.oci_lz_zpr] # network_configuration may have ZPR attributes that must exist up front.
  count                   = var.network_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-networking.git?ref=v0.7.5"
  network_configuration   = var.network_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.ext_dep_network_map
  private_ips_dependency  = local.nlbs_dependency
  tenancy_ocid            = var.tenancy_ocid
}

# Network Load Balancers
module "oci_lz_nlb" {
  count                   = var.nlb_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-networking.git//modules/nlb?ref=v0.7.5"
  nlb_configuration       = var.nlb_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  instances_dependency    = local.instances_dependency
}
