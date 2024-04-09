# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# Core networking
module "oci_lz_network" {
  count                   = var.network_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking.git?ref=v0.6.5"
  network_configuration   = var.network_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.ext_dep_network_map
}

# Network Load Balancers
module "oci_lz_nlb" {
  count                   = var.nlb_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking.git//modules/nlb?ref=v0.6.5"
  nlb_configuration       = var.nlb_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  instances_dependency    = local.instances_dependency
}