# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "this" {
  count          = (lower(var.configuration_source) == "ocibucket") || lower(var.url_dependency_source) == "ocibucket" ? 1 : 0
  compartment_id = var.tenancy_ocid
}

data "oci_objectstorage_object" "configurations" {
  count     = lower(var.configuration_source) == "ocibucket" && var.oci_configuration_bucket != null && var.oci_configuration_objects != null ? length(var.oci_configuration_objects) : 0
  bucket    = var.oci_configuration_bucket
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_configuration_objects[count.index]
}

data "github_repository_file" "configurations" {
  count      = lower(var.configuration_source) == "github" && var.github_configuration_files != null ? length(var.github_configuration_files) : 0
  repository = var.github_configuration_repo
  branch     = var.github_configuration_branch
  file       = var.github_configuration_files[count.index]
}

data "http" "configurations" {
  count = lower(var.configuration_source) == "url" && var.input_config_files_urls != null ? length(var.input_config_files_urls) : 0
  url   = var.input_config_files_urls[count.index]
  request_headers = {
    Accept = "application/json"
  }
}

locals {

  # JSON inputs
  ocibucket_json_configs = [for element in flatten(data.oci_objectstorage_object.configurations[*].content) : jsondecode(element) if length(data.oci_objectstorage_object.configurations) > 0 && try(jsondecode(element), null) != null]
  github_json_configs    = [for element in flatten(data.github_repository_file.configurations[*].content) : jsondecode(element) if length(data.github_repository_file.configurations) > 0 && try(jsondecode(element), null) != null]
  url_json_configs       = [for element in flatten(data.http.configurations[*].body) : jsondecode(element) if length(data.http.configurations) > 0 && try(jsondecode(element), null) != null]
  all_json_configs       = concat(local.ocibucket_json_configs, local.github_json_configs, local.url_json_configs)

  all_json_configs_keys = flatten([for config in local.all_json_configs : keys(config) if length(local.all_json_configs) > 0])
  all_json_configs_map = { for key in local.all_json_configs_keys :
    key => [for config in local.all_json_configs : config[key] if contains(keys(config), key)][0]
  if length(local.all_json_configs_keys) > 0 }

  # YAML inputs
  ocibucket_yaml_configs = [for element in flatten(data.oci_objectstorage_object.configurations[*].content) : yamldecode(element) if length(data.oci_objectstorage_object.configurations) > 0 && try(yamldecode(element), null) != null]
  github_yaml_configs    = [for element in flatten(data.github_repository_file.configurations[*].content) : yamldecode(element) if length(data.github_repository_file.configurations) > 0 && try(yamldecode(element), null) != null]
  url_yaml_configs       = [for element in flatten(data.http.configurations[*].body) : yamldecode(element) if length(data.http.configurations) > 0 && try(yamldecode(element), null) != null]
  all_yaml_configs       = concat(local.ocibucket_yaml_configs, local.github_yaml_configs, local.url_yaml_configs)

  all_yaml_configs_keys = flatten([for value in local.all_yaml_configs : keys(value) if length(local.all_yaml_configs) > 0])
  all_yaml_configs_map = { for key in local.all_yaml_configs_keys :
    key => [for config in local.all_yaml_configs : config[key] if contains(keys(config), key)][0]
  if length(local.all_yaml_configs_keys) > 0 }


  merged_input_configs = merge(local.all_json_configs_map, local.all_yaml_configs_map)

  # IAM
  compartments_configuration   = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "compartments_configuration") ? local.merged_input_configs.compartments_configuration : null : null
  groups_configuration         = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "groups_configuration") ? local.merged_input_configs.groups_configuration : null : null
  dynamic_groups_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "dynamic_groups_configuration") ? local.merged_input_configs.dynamic_groups_configuration : null : null
  policies_configuration       = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "policies_configuration") ? local.merged_input_configs.policies_configuration : null : null

  # IAM Identity Domains
  identity_domains_configuration                   = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "identity_domains_configuration") ? local.merged_input_configs.identity_domains_configuration : null : null
  identity_domain_groups_configuration             = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "identity_domain_groups_configuration") ? local.merged_input_configs.identity_domain_groups_configuration : null : null
  identity_domain_dynamic_groups_configuration     = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "identity_domain_dynamic_groups_configuration") ? local.merged_input_configs.identity_domain_dynamic_groups_configuration : null : null
  identity_domain_identity_providers_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "identity_domain_identity_providers_configuration") ? local.merged_input_configs.identity_domain_identity_providers_configuration : null : null
  identity_domain_applications_configuration       = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "identity_domain_applications_configuration") ? local.merged_input_configs.identity_domain_applications_configuration : null : null

  # Networking
  network_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "network_configuration") ? local.merged_input_configs.network_configuration : null : null
  nlb_configuration     = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "nlb_configuration") ? local.merged_input_configs.nlb_configuration : null : null

  # Observability
  streams_configuration            = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "streams_configuration") ? local.merged_input_configs.streams_configuration : null : null
  service_connectors_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "service_connectors_configuration") ? local.merged_input_configs.service_connectors_configuration : null : null
  logging_configuration            = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "logging_configuration") ? local.merged_input_configs.logging_configuration : null : null
  notifications_configuration      = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "notifications_configuration") ? local.merged_input_configs.notifications_configuration : null : null
  events_configuration             = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "events_configuration") ? local.merged_input_configs.events_configuration : null : null
  home_region_events_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "home_region_events_configuration") ? local.merged_input_configs.home_region_events_configuration : null : null
  alarms_configuration             = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "alarms_configuration") ? local.merged_input_configs.alarms_configuration : null : null

  # Security
  scanning_configuration       = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "scanning_configuration") ? local.merged_input_configs.scanning_configuration : null : null
  cloud_guard_configuration    = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "cloud_guard_configuration") ? local.merged_input_configs.cloud_guard_configuration : null : null
  security_zones_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "security_zones_configuration") ? local.merged_input_configs.security_zones_configuration : null : null
  vaults_configuration         = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "vaults_configuration") ? local.merged_input_configs.vaults_configuration : null : null
  zpr_configuration            = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "zpr_configuration") ? local.merged_input_configs.zpr_configuration : null : null
  bastions_configuration       = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "bastions_configuration") ? local.merged_input_configs.bastions_configuration : null : null

  # Governance
  tags_configuration    = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "tags_configuration") ? local.merged_input_configs.tags_configuration : null : null
  budgets_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "budgets_configuration") ? local.merged_input_configs.budgets_configuration : null : null

  # Object Storage
  object_storage_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "object_storage_configuration") ? local.merged_input_configs.object_storage_configuration : null : null

  # Compute
  instances_configuration = local.merged_input_configs != null ? contains(keys(local.merged_input_configs), "instances_configuration") ? local.merged_input_configs.instances_configuration : null : null
}