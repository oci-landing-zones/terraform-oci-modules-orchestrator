# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_compute" {
  depends_on = [module.oci_lz_zpr] # instances_configuration may have ZPR attributes that must exist up front.
  count      = var.instances_configuration != null ? 1 : 0
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-compute-storage?ref=v0.2.3"
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
  depends_on              = [module.oci_lz_zpr] # clusters_configuration may have ZPR attributes that must exist up front.
  count                   = var.oke_clusters_configuration != null || var.oke_workers_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-oke?ref=v0.2.3"
  clusters_configuration  = var.oke_clusters_configuration
  workers_configuration   = var.oke_workers_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
}

module "oci_lz_autonomous_database" {
  depends_on = [module.oci_lz_zpr]
  count      = var.autonomous_databases_configuration != null ? 1 : 0
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-exadata.git//autonomous-database?ref=v1.1.0"
  providers = {
    oci      = oci
    oci.home = oci.home
  }
  tenancy_ocid                       = var.tenancy_ocid
  autonomous_databases_configuration = var.autonomous_databases_configuration
  compartments_dependency            = local.compartments_dependency
  network_dependency                 = local.network_dependency
  kms_dependency                     = local.kms_dependency
  databases_dependency               = local.databases_dependency
}

module "oci_lz_exadata" {
  depends_on                                  = [module.oci_lz_zpr] # Exadata network resources may have ZPR attributes that must exist up front.
  count                                       = var.exadata_cloud_infrastructures_configuration != null || var.exadata_cloud_vm_clusters_configuration != null || var.exadata_db_homes_configuration != null || var.exadata_databases_configuration != null || var.exadata_pluggable_databases_configuration != null ? 1 : 0
  source                                      = "git::https://github.com/oci-landing-zones/terraform-oci-modules-exadata.git//exadata-database?ref=v1.1.0"
  cloud_exadata_infrastructures_configuration = var.exadata_cloud_infrastructures_configuration
  cloud_vm_clusters_configuration             = var.exadata_cloud_vm_clusters_configuration
  cloud_db_homes_configuration                = var.exadata_db_homes_configuration
  databases_configuration                     = var.exadata_databases_configuration
  pluggable_databases_configuration           = var.exadata_pluggable_databases_configuration
  compartments_dependency                     = local.compartments_dependency
  network_dependency                          = local.network_dependency
  subscription_dependency                     = var.exadata_subscription_dependency
}
