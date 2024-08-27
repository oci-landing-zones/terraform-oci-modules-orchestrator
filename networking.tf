# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# Core networking
module "oci_lz_network" {
  count                   = var.network_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-networking.git?ref=release-0.6.9"
  network_configuration   = var.network_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.ext_dep_network_map
  private_ips_dependency  = local.nlbs_dependency 
}

# Network Load Balancers
module "oci_lz_nlb" {
  count                   = var.nlb_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-networking.git//modules/nlb?ref=release-0.6.9"
  nlb_configuration       = var.nlb_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  instances_dependency    = local.instances_dependency
}