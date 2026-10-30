# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_budgets" {
  count                   = var.budgets_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//budgets?ref=v0.1.6"
  tenancy_ocid            = var.tenancy_ocid
  budgets_configuration   = var.budgets_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_tags" {
  count                   = var.tags_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags/namespaces-and-tags?ref=refactor/composable-tags"
  tenancy_ocid            = var.tenancy_ocid
  tags_configuration      = var.tags_configuration
  compartments_dependency = local.ext_dep_compartments_map
}

module "oci_lz_tag_defaults" {
  count                      = var.tags_configuration != null ? 1 : 0
  source                     = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags/defaults?ref=refactor/composable-tags"
  tenancy_ocid               = var.tenancy_ocid
  tag_defaults_configuration = module.oci_lz_tags[0].tag_defaults_configuration
  # Preserve existing external aliases when a managed compartment uses the same key.
  compartments_dependency = merge(
    local.compartments_dependency,
    { for key, compartment in coalesce(local.ext_dep_compartments_map, {}) : key => { id = compartment.id } }
  )

  depends_on = [module.oci_lz_compartments]
}

moved {
  from = module.oci_lz_tags[0].oci_identity_tag_default.these
  to   = module.oci_lz_tag_defaults[0].oci_identity_tag_default.these
}

resource "time_sleep" "tag_propagation" {
  count = var.tags_configuration != null ? 1 : 0

  # Tags are cross-region resources, so allow time for their creation to complete before compartments that use them are created.
  create_duration = "10s"

  depends_on = [module.oci_lz_tags]
}
