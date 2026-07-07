# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_regions" "these" {}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

locals {
  regions_map         = { for r in data.oci_identity_regions.these.regions : r.key => r.name } # All regions indexed by region key.
  regions_map_reverse = { for r in data.oci_identity_regions.these.regions : r.name => r.key } # All regions indexed by region name.
  home_region_key     = data.oci_identity_tenancy.this.home_region_key                         # Home region key obtained from the tenancy data source
  region_key          = lower(local.regions_map_reverse[var.region])                           # Region key obtained from the region name
}

provider "oci" {
  auth                 = var.auth
  config_file_profile  = var.config_file_profile
  config_file          = var.config_file
  region               = var.region
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
  ignore_defined_tags  = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
}

provider "oci" {
  alias                = "home"
  auth                 = var.auth
  config_file_profile  = var.config_file_profile
  config_file          = var.config_file
  region               = local.regions_map[local.home_region_key]
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
  ignore_defined_tags  = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
}

provider "oci" {
  alias                = "secondary_region"
  auth                 = var.auth
  config_file_profile  = var.config_file_profile
  config_file          = var.config_file
  region               = local.regions_map[local.home_region_key]
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
  ignore_defined_tags  = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    oci = {
      source                = "oracle/oci"
      configuration_aliases = [oci.home]
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.9.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}
