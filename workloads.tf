# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_compute" {
  depends_on = [module.oci_lz_zpr] # instances_configuration may have ZPR attributes that must exist up front.
  count      = var.instances_configuration != null ? 1 : 0
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-compute-storage?ref=v0.2.8"
  providers = {
    oci                                  = oci
    oci.block_volumes_replication_region = oci
  }
  tenancy_ocid            = var.tenancy_ocid
  instances_configuration = var.instances_configuration
  storage_configuration   = var.storage_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
  #  instances_dependency    = TBD
  #  file_system_dependency  = TBD
}

module "oke_compatibility" {
  source                 = "./modules/oke-compatibility"
  clusters_configuration = var.oke_clusters_configuration
  workers_configuration  = var.oke_workers_configuration
}

module "oci_lz_oke" {
  # Discovery must not depend on apply-time validation/ZPR resources.
  for_each                = module.oke_compatibility.clusters
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-oke?ref=036b6eac9e365535dddcdf382a888baaebe635ea"
  providers               = { oci = oci }
  cluster_configuration   = each.value
  workers_configuration   = module.oke_compatibility.workers[each.key]
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
}

locals {
  oke_clusters           = { for k, m in module.oci_lz_oke : k => m.cluster }
  oke_node_pools         = merge({}, [for m in values(module.oci_lz_oke) : m.node_pools]...)
  oke_nodes              = merge({}, [for m in values(module.oci_lz_oke) : m.nodes]...)
  oke_virtual_node_pools = merge({}, [for m in values(module.oci_lz_oke) : m.virtual_node_pools]...)
}

module "oci_lz_ocvs" {
  depends_on              = [module.oci_lz_zpr] # ocvs_configuration may have ZPR attributes that must exist up front.
  count                   = var.ocvs_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-workloads-ocvs.git//ocvs/modules/ocvs?ref=v1.1.0"
  tenancy_ocid            = var.tenancy_ocid
  ocvs_configuration      = var.ocvs_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.ocvs_network_dependency
}

module "oci_lz_cloud_exadata_database" {
  depends_on = [module.oci_lz_zpr] # cloud_exadata_database_configuration may have ZPR attributes that must exist up front.
  count      = var.cloud_exadata_database_configuration != null ? 1 : 0
  source     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-exadata.git//exadata-database?ref=v1.1.0"

  cloud_exadata_infrastructures_configuration = try(var.cloud_exadata_database_configuration.cloud_exadata_infrastructures_configuration, null)
  cloud_vm_clusters_configuration             = try(var.cloud_exadata_database_configuration.cloud_vm_clusters_configuration, null)
  cloud_db_homes_configuration                = try(var.cloud_exadata_database_configuration.cloud_db_homes_configuration, null)
  databases_configuration                     = try(var.cloud_exadata_database_configuration.databases_configuration, null)
  pluggable_databases_configuration           = try(var.cloud_exadata_database_configuration.pluggable_databases_configuration, null)
  default_compartment_id                      = try(var.cloud_exadata_database_configuration.default_compartment_id, null)
  default_defined_tags                        = try(var.cloud_exadata_database_configuration.default_defined_tags, {})
  default_freeform_tags                       = try(var.cloud_exadata_database_configuration.default_freeform_tags, {})
  compartments_dependency                     = local.compartments_dependency
  subscription_dependency                     = local.subscription_dependency
  network_dependency                          = local.network_dependency
}

module "oci_lz_autonomous_databases" {
  depends_on = [module.oci_lz_zpr] # autonomous_databases_configuration may have ZPR attributes that must exist up front.
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
