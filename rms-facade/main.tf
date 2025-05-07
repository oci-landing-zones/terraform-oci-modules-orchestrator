# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_orchestrator" {
  source = "../"

  tenancy_ocid         = var.tenancy_ocid
  region               = var.region
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password

  # Configurations
  # IAM
  compartments_configuration   = local.compartments_configuration
  groups_configuration         = local.groups_configuration
  dynamic_groups_configuration = local.dynamic_groups_configuration
  policies_configuration       = local.policies_configuration
  # IAM Identity Domains
  identity_domains_configuration                   = local.identity_domains_configuration
  identity_domain_groups_configuration             = local.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration     = local.identity_domain_dynamic_groups_configuration
  identity_domain_identity_providers_configuration = local.identity_domain_identity_providers_configuration
  identity_domain_applications_configuration       = local.identity_domain_applications_configuration
  # Networking
  network_configuration = local.network_configuration
  nlb_configuration     = local.nlb_configuration
  # Observability
  streams_configuration            = local.streams_configuration
  service_connectors_configuration = local.service_connectors_configuration
  logging_configuration            = local.logging_configuration
  notifications_configuration      = local.notifications_configuration
  events_configuration             = local.events_configuration
  home_region_events_configuration = local.home_region_events_configuration
  alarms_configuration             = local.alarms_configuration
  # Security
  scanning_configuration       = local.scanning_configuration
  cloud_guard_configuration    = local.cloud_guard_configuration
  security_zones_configuration = local.security_zones_configuration
  vaults_configuration         = local.vaults_configuration
  zpr_configuration            = local.zpr_configuration
  bastions_configuration       = local.bastions_configuration
  # Governance
  budgets_configuration = local.budgets_configuration
  tags_configuration    = local.tags_configuration
  # Object Storage
  object_storage_configuration = local.object_storage_configuration
  # Compute
  instances_configuration = local.instances_configuration

  # Dependencies
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  tags_dependency         = local.tags_dependency
  kms_dependency          = local.kms_dependency
  streams_dependency      = local.streams_dependency
  topics_dependency       = local.topics_dependency
  logging_dependency      = local.logging_dependency
  functions_dependency    = local.functions_dependency
  vaults_dependency       = local.vaults_dependency
  instances_dependency    = local.instances_dependency
  nlbs_dependency         = local.nlbs_dependency
}