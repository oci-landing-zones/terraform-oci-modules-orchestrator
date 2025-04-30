# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_compartments" {
  count                      = var.compartments_configuration != null ? 1 : 0
  source                     = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//compartments?ref=v0.2.9"
  providers                  = { oci = oci.home }
  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = var.compartments_configuration
  compartments_dependency    = local.ext_dep_compartments_map
  tags_dependency            = local.tags_dependency
}

module "oci_lz_groups" {
  count                = var.groups_configuration != null ? 1 : 0
  source               = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//groups?ref=v0.2.9"
  providers            = { oci = oci.home }
  tenancy_ocid         = var.tenancy_ocid
  groups_configuration = var.groups_configuration
}

module "oci_lz_dynamic_groups" {
  count                        = var.dynamic_groups_configuration != null ? 1 : 0
  source                       = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//dynamic-groups?ref=v0.2.9"
  providers                    = { oci = oci.home }
  tenancy_ocid                 = var.tenancy_ocid
  dynamic_groups_configuration = var.dynamic_groups_configuration
}

module "oci_lz_policies" {
  count                   = var.policies_configuration != null ? 1 : 0
  depends_on              = [module.oci_lz_compartments, module.oci_lz_groups, module.oci_lz_dynamic_groups]
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//policies?ref=v0.2.9"
  providers               = { oci = oci.home }
  tenancy_ocid            = var.tenancy_ocid
  policies_configuration  = var.policies_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_identity_domains" {
  count                                            = var.identity_domains_configuration != null ? 1 : 0
  source                                           = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//identity-domains?ref=v0.2.9"
  providers                                        = { oci = oci.home }
  tenancy_ocid                                     = var.tenancy_ocid
  identity_domains_configuration                   = var.identity_domains_configuration
  identity_domain_groups_configuration             = var.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration     = var.identity_domain_dynamic_groups_configuration
  identity_domain_identity_providers_configuration = var.identity_domain_identity_providers_configuration
  identity_domain_applications_configuration       = var.identity_domain_applications_configuration
  compartments_dependency                          = local.compartments_dependency
}
