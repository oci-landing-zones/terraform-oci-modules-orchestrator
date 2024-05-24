# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_compute" {
  count                   = var.instances_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-secure-workloads.git//cis-compute-storage?ref=release-0.1.4-rms"
  providers = {
    oci = oci
    oci.block_volumes_replication_region = oci
  }
  instances_configuration = var.instances_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = local.kms_dependency
#  instances_dependency    = TBD
#  file_system_dependency  = TBD
}