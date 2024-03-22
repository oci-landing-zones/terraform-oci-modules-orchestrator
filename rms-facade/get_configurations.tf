# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "this" {
  count = (var.save_output && lower(var.configuration_source) == "ocibucket") || lower(var.configuration_source) == "ocibucket" ? 1 : 0
  compartment_id = var.tenancy_ocid
}

data "oci_objectstorage_object" "configurations" {
  count = lower(var.configuration_source) == "ocibucket" && var.oci_configuration_bucket != null && var.oci_configuration_objects != null ? length(var.oci_configuration_objects) : 0
  bucket    = var.oci_configuration_bucket
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_configuration_objects[count.index]
}

data "github_repository_file" "configurations" {
  count = lower(var.configuration_source) == "github" && var.github_configuration_files != null ? length(var.github_configuration_files) : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = var.github_configuration_files[count.index]
}

data "http" "configurations" {
  count = lower(var.configuration_source) == "url" && var.input_config_files_urls != null ? length(var.input_config_files_urls) : 0
  url = var.input_config_files_urls[count.index]
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  /* all_json_config_files = data.http.configurations != null ? length(data.http.configurations) > 0 ? [
    for element in concat(flatten(data.http.configurations[*].body),flatten(data.oci_objectstorage_object.configurations[*].content)) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : null : null */

  ocibucket_json_config_files = data.oci_objectstorage_object.configurations != null ? length(data.oci_objectstorage_object.configurations) > 0 ? [
    for element in flatten(data.oci_objectstorage_object.configurations[*].content) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : [] : []

  github_json_config_files = data.github_repository_file.configurations != null ? length(data.github_repository_file.configurations) > 0 ? [
    for element in flatten(data.github_repository_file.configurations[*].content) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : [] : []

  url_json_config_files = data.http.configurations != null ? length(data.http.configurations) > 0 ? [
    for element in flatten(data.http.configurations[*].body) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : [] : []

  all_json_config_files = concat(local.ocibucket_json_config_files, local.github_json_config_files, local.url_json_config_files)

  ocibucket_yaml_config_files = data.oci_objectstorage_object.configurations != null ? length(data.oci_objectstorage_object.configurations) > 0 ? [
    for element in flatten(data.oci_objectstorage_object.configurations[*].content) : yamldecode(element) if try(yamldecode(element), null) != null
  ] : [] : []

  github_yaml_config_files = data.github_repository_file.configurations != null ? length(data.github_repository_file.configurations) > 0 ? [
    for element in flatten(data.github_repository_file.configurations[*].content) : yamldecode(element) if try(yamldecode(element), null) != null
  ] : [] : []

  url_yaml_config_files = data.http.configurations != null ? length(data.http.configurations) > 0 ? [
    for element in flatten(data.http.configurations[*].body) : yamldecode(element) if try(yamldecode(element), null) != null
  ] : [] : []

  all_yaml_config_files = concat(local.ocibucket_yaml_config_files, local.github_yaml_config_files, local.url_yaml_config_files)

  /* all_non_json_config_files = data.http.configurations != null ? length(data.http.configurations) > 0 ? [
    for element in flatten(data.http.configurations[*]) : element.url if try(jsondecode(element.body), null) == null
  ] : null : null */

  /* all_non_yaml_config_files = data.http.configurations != null ? length(data.http.configurations) > 0 ? [
    for element in flatten(data.http.configurations[*]) : element.url if try(yamldecode(element.body), null) == null
  ] : null : null */

  //all_non_json_non_yaml_config_files = merge(local.all_non_json_config_files, local.all_non_yaml_config_files)

  all_json_config_l1_keys = local.all_json_config_files != null ? length(local.all_json_config_files) > 0 ? flatten([
    for value in local.all_json_config_files : keys(value) if value != null
  ]) : null : null

  merged_input_json_config_files = local.all_json_config_l1_keys != null ? length(local.all_json_config_l1_keys) > 0 ? {
    for key in local.all_json_config_l1_keys : key => [
      for config in local.all_json_config_files : config[key] if contains(keys(config), key) && config != null
    ][0]
  } : null : null

  all_yaml_config_l1_keys = local.all_yaml_config_files != null ? length(local.all_yaml_config_files) > 0 ? flatten([
    for value in local.all_yaml_config_files : keys(value) if value != null
  ]) : null : null

  merged_input_yaml_config_files = local.all_yaml_config_l1_keys != null ? length(local.all_yaml_config_l1_keys) > 0 ? {
    for key in local.all_yaml_config_l1_keys : key => [
      for config in local.all_yaml_config_files : config[key] if contains(keys(config), key) && config != null
    ][0]
  } : null : null


  merged_input_config_files = merge(local.merged_input_json_config_files, local.merged_input_yaml_config_files)

  # IAM
  compartments_configuration   = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "compartments_configuration") ? local.merged_input_config_files.compartments_configuration : null : null
  groups_configuration         = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "groups_configuration") ? local.merged_input_config_files.groups_configuration : null : null
  dynamic_groups_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "dynamic_groups_configuration") ? local.merged_input_config_files.dynamic_groups_configuration : null : null
  policies_configuration       = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "policies_configuration") ? local.merged_input_config_files.policies_configuration : null : null

  # Networking - core
  network_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "network_configuration") ? local.merged_input_config_files.network_configuration : null : null

  # Networking - firewall
  nlb_configuration       = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "nlb_configuration") ? local.merged_input_config_files.nlb_configuration : null : null
  instances_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "instances_configuration") ? local.merged_input_config_files.instances_configuration : null : null

  # Observability
  streams_configuration            = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "streams_configuration") ? local.merged_input_config_files.streams_configuration : null : null
  service_connectors_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "service_connectors_configuration") ? local.merged_input_config_files.service_connectors_configuration : null : null
  logging_configuration            = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "logging_configuration") ? local.merged_input_config_files.logging_configuration : null : null
  notifications_configuration      = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "notifications_configuration") ? local.merged_input_config_files.notifications_configuration : null : null
  events_configuration             = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "events_configuration") ? local.merged_input_config_files.events_configuration : null : null
  home_region_events_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "home_region_events_configuration") ? local.merged_input_config_files.home_region_events_configuration : null : null
  alarms_configuration             = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "alarms_configuration") ? local.merged_input_config_files.alarms_configuration : null : null

  # Security
  scanning_configuration       = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "scanning_configuration") ? local.merged_input_config_files.scanning_configuration : null : null
  cloud_guard_configuration    = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "cloud_guard_configuration") ? local.merged_input_config_files.cloud_guard_configuration : null : null
  security_zones_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "security_zones_configuration") ? local.merged_input_config_files.security_zones_configuration : null : null
  vaults_configuration         = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "vaults_configuration") ? local.merged_input_config_files.vaults_configuration : null : null

  # Governance
  tags_configuration    = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "tags_configuration") ? local.merged_input_config_files.tags_configuration : null : null
  budgets_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "budgets_configuration") ? local.merged_input_config_files.budgets_configuration : null : null

  # Object Storage
  object_storage_configuration = local.merged_input_config_files != null ? contains(keys(local.merged_input_config_files), "object_storage_configuration") ? local.merged_input_config_files.object_storage_configuration : null : null
}