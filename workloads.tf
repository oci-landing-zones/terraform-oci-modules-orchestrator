# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_compute" {
  depends_on = [module.oci_lz_zpr] # instances_configuration may have ZPR attributes that must exist up front.
  count      = var.instances_configuration != null ? 1 : 0
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-compute-storage?ref=v0.2.1"
  providers = {
    oci                                  = oci
    oci.block_volumes_replication_region = oci
  }
  tenancy_ocid            = var.tenancy_ocid
  instances_configuration = var.instances_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
  #  instances_dependency    = TBD
  #  file_system_dependency  = TBD
}

module "oci_lz_oke" {
  depends_on = [module.oci_lz_zpr] # clusters_configuration may have ZPR attributes that must exist up front.
  count      = var.oke_clusters_configuration != null || var.oke_workers_configuration != null ? 1 : 0
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-oke?ref=v0.2.1"
  clusters_configuration  = var.oke_clusters_configuration
  workers_configuration   = var.oke_workers_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
}
