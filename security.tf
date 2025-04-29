# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_scanning" {
  count                   = var.scanning_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//vss?ref=v0.2.0"
  scanning_configuration  = var.scanning_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_cloud_guard" {
  count                     = var.cloud_guard_configuration != null ? 1 : 0
  source                    = "git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//cloud-guard?ref=v0.2.0"
  tenancy_ocid              = var.tenancy_ocid
  cloud_guard_configuration = var.cloud_guard_configuration
  compartments_dependency   = local.compartments_dependency
}

module "oci_lz_security_zones" {
  count                        = var.security_zones_configuration != null ? 1 : 0
  source                       = "git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//security-zones?ref=v0.2.0"
  tenancy_ocid                 = var.tenancy_ocid
  security_zones_configuration = var.security_zones_configuration
  compartments_dependency      = local.compartments_dependency
}

module "oci_lz_vaults" {
  count  = var.vaults_configuration != null ? 1 : 0
  source = "git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//vaults?ref=v0.2.0"
  providers = {
    oci      = oci
    oci.home = oci.home
  }
  vaults_configuration    = var.vaults_configuration
  compartments_dependency = local.compartments_dependency
  vaults_dependency       = local.ext_dep_vaults_map
}

module "oci_lz_zpr" {
  count  = var.zpr_configuration != null ? 1 : 0
  source = "git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//zpr?ref=v0.2.0"
  providers = {
    oci = oci.home
  }
  zpr_configuration       = var.zpr_configuration
  compartments_dependency = local.compartments_dependency
  tenancy_ocid            = var.tenancy_ocid
}

module "oci_lz_bastions" {
  count                   = var.bastions_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//bastion?ref=v0.2.0"
  bastions_configuration  = var.bastions_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
}