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
  compartments_configuration   = local.compartments_configuration_from_input_json_yaml_file
  groups_configuration         = local.groups_configuration_from_input_json_yaml_file
  dynamic_groups_configuration = local.dynamic_groups_configuration_from_input_json_yaml_file
  policies_configuration       = local.policies_configuration_from_input_json_yaml_file
  # Networking
  network_configuration        = local.network_configuration_from_input_json_yaml_file
  # Observability
  streams_configuration            = local.streams_configuration_from_input_json_yaml_file
  service_connectors_configuration = local.service_connectors_configuration_from_input_json_yaml_file
  logging_configuration            = local.logging_configuration_from_input_json_yaml_file
  notifications_configuration      = local.notifications_configuration_from_input_json_yaml_file
  events_configuration             = local.events_configuration_from_input_json_yaml_file
  home_region_events_configuration = local.home_region_events_configuration_from_input_json_yaml_file
  alarms_configuration             = local.alarms_configuration_from_input_json_yaml_file

  # Dependencies
  compartments_dependency      = local.compartments_dependency
  networks_dependency          = local.networks_dependency
  tags_dependency              = local.tags_dependency
  kms_dependency               = local.kms_dependency
  streams_dependency           = local.streams_dependency
  topics_dependency            = local.topics_dependency
  logging_dependency           = local.logging_dependency
  functions_dependency         = local.functions_dependency

}