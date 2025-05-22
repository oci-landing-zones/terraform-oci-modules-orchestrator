# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    oci = {
      source = "oracle/oci"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  region               = var.region
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
}

provider "github" {
  token    = var.github_token != null ? var.github_token : (var.url_dependency_source_github_token != null ? var.url_dependency_source_github_token : null)
  base_url = var.github_base_url
  # Workaround for github_repository_file commiting across organizations
  # See `rms-facade/outputs.tf` Github section for details 
  owner = var.github_configuration_repo != null ? split("/", var.github_configuration_repo)[0] : null
}

