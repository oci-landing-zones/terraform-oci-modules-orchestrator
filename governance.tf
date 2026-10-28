# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_budgets" {
  depends_on              = [time_sleep.tag_defaults_propagation]
  count                   = var.budgets_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//budgets?ref=v0.1.6"
  tenancy_ocid            = var.tenancy_ocid
  budgets_configuration   = var.budgets_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_tags" {
  count                   = var.tags_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags?ref=v0.1.6"
  tenancy_ocid            = var.tenancy_ocid
  tags_configuration      = local.tags_configuration_without_defaults
  compartments_dependency = local.ext_dep_compartments_map
}

resource "time_sleep" "tag_propagation" {
  count = var.tags_configuration != null ? 1 : 0

  # Tags are cross-region resources, so allow time for their creation to complete before compartments that use them are created.
  create_duration = "10s"
  triggers = {
    tags = sha256(jsonencode(module.oci_lz_tags[0].tags))
  }

  depends_on = [module.oci_lz_tags]
}
