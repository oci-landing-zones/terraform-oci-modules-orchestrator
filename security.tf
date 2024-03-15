# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_scanning" {
  count  = var.scanning_configuration != null ? 1 : 0
  source = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security.git//vss?ref=v0.1.2"
  scanning_configuration  = var.scanning_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_cloud_guard" {
  count  = var.cloud_guard_configuration != null ? 1 : 0
  source = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security.git//cloud-guard?ref=v0.1.2"
  cloud_guard_configuration = var.cloud_guard_configuration
  compartments_dependency   = local.compartments_dependency
}

module "oci_lz_security_zones" {
  count  = var.security_zones_configuration != null ? 1 : 0
  source = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security.git//security-zones?ref=v0.1.2"
  security_zones_configuration = var.security_zones_configuration
  compartments_dependency      = local.compartments_dependency
}

module "oci_lz_vaults" {
  count  = var.vaults_configuration != null ? 1 : 0
  source = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security.git//vaults?ref=v0.1.2"
  providers = {
    oci = oci
    oci.home = oci.home
  }
  vaults_configuration    = var.vaults_configuration
  compartments_dependency = local.compartments_dependency
  vaults_dependency       = var.vaults_dependency #merge({for k, v in coalesce(var.vaults_dependency,{}) : k => {"management_endpoint" : v.management_endpoint}}, {for k, v in (length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].vaults : {}) : k => {"management_endpoint" : v.management_endpoint}})
}