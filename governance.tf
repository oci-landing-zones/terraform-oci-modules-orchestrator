# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_budgets" {
  count                   = var.budgets_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//budgets?ref=v0.1.5"
  tenancy_ocid            = var.tenancy_ocid
  budgets_configuration   = var.budgets_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_tags" {
  count                   = var.tags_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags?ref=v0.1.5"
  tenancy_ocid            = var.tenancy_ocid
  tags_configuration      = var.tags_configuration
  compartments_dependency = local.ext_dep_compartments_map
  #compartments_dependency = local.compartments_dependency
}
