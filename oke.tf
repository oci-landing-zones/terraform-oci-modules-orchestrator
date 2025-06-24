# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_oke" {
  depends_on = [module.oci_lz_zpr] # clusters_configuration may have ZPR attributes that must exist up front.
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-oke?ref=v0.2.0"
  clusters_configuration  = var.clusters_configuration
  workers_configuration   = var.workers_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
}