# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_object" "dependencies" {
  count     = lower(var.configuration_source) == "ocibucket" && var.oci_configuration_bucket != null && var.oci_dependency_objects != null ? length(var.oci_dependency_objects) : 0
  bucket    = var.oci_configuration_bucket
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_dependency_objects[count.index]
}

data "github_repository_file" "dependencies" {
  count      = lower(var.configuration_source) == "github" && var.github_dependency_files != null ? length(var.github_dependency_files) : 0
  repository = var.github_configuration_repo
  branch     = var.github_configuration_branch
  file       = var.github_dependency_files[count.index]
}

# data "http" "dependencies" {
#   count = var.dependency_files_urls != null ? length(var.dependency_files_urls) : 0
#   url = var.dependency_files_urls[count.index]
#   request_headers = {
#     Accept = "application/json"
#   }
# }

data "oci_objectstorage_object" "url_dependencies" {
  count     = lower(var.configuration_source) == "url" && var.url_dependency_source_oci_bucket != null && var.url_dependency_source_oci_objects != null ? length(var.url_dependency_source_oci_objects) : 0
  bucket    = var.url_dependency_source_oci_bucket
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.url_dependency_source_oci_objects[count.index]
}

data "github_repository_file" "url_dependencies" {
  count      = lower(var.configuration_source) == "url" && var.url_dependency_source_github_dependency_files != null ? length(var.url_dependency_source_github_dependency_files) : 0
  repository = var.url_dependency_source_github_repo
  branch     = var.url_dependency_source_github_branch
  file       = var.url_dependency_source_github_dependency_files[count.index]
}

locals {
  #url_json_dependencies = [for element in flatten(data.http.dependencies[*].body) : try(jsondecode(element), "") if length(data.http.dependencies) > 0]
  url_ocibucket_json_dependencies = [for element in flatten(data.oci_objectstorage_object.url_dependencies[*].content) : try(jsondecode(element), "") if length(data.oci_objectstorage_object.url_dependencies) > 0]
  url_github_json_dependencies    = [for element in flatten(data.github_repository_file.url_dependencies[*].content) : try(jsondecode(element), "") if length(data.github_repository_file.url_dependencies) > 0]
  ocibucket_json_dependencies     = [for element in flatten(data.oci_objectstorage_object.dependencies[*].content) : try(jsondecode(element), "") if length(data.oci_objectstorage_object.dependencies) > 0]
  github_json_dependencies        = [for element in flatten(data.github_repository_file.dependencies[*].content) : try(jsondecode(element), "") if length(data.github_repository_file.dependencies) > 0]
  #all_json_dependencies = concat(local.url_json_dependencies, local.ocibucket_json_dependencies, local.github_json_dependencies)
  all_json_dependencies = concat(local.url_ocibucket_json_dependencies, local.url_github_json_dependencies, local.ocibucket_json_dependencies, local.github_json_dependencies)

  all_json_dependencies_keys = flatten([for value in local.all_json_dependencies : keys(value) if length(local.all_json_dependencies) > 0])

  all_json_dependencies_map = { for key in local.all_json_dependencies_keys :
    key => [for config in local.all_json_dependencies : config[key] if contains(keys(config), key)][0]
  if length(local.all_json_dependencies_keys) > 0 }

  compartments_dependency = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "compartments") ? { "compartments" : local.all_json_dependencies_map.compartments } : null : null
  tags_dependency         = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "tags") ? { "tags" : local.all_json_dependencies_map.tags } : null : null
  network_dependency      = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "network_resources") ? { "network_resources" : local.all_json_dependencies_map.network_resources } : null : null
  kms_dependency          = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "keys") ? { "keys" : local.all_json_dependencies_map.keys } : null : null
  streams_dependency      = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "streams") ? { "streams" : local.all_json_dependencies_map.streams } : null : null
  topics_dependency       = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "topics") ? { "topics" : local.all_json_dependencies_map.topics } : null : null
  logging_dependency      = local.all_json_dependencies_map != null ? merge(contains(keys(local.all_json_dependencies_map), "service_logs") ? { "service_logs" : local.all_json_dependencies_map.service_logs } : {}, contains(keys(local.all_json_dependencies_map), "custom_logs") ? { "custom_logs" : local.all_json_dependencies_map.custom_logs } : {}) : null
  functions_dependency    = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "functions") ? { "functions" : local.all_json_dependencies_map.functions } : null : null
  vaults_dependency       = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "vaults") ? { "vaults" : local.all_json_dependencies_map.vaults } : null : null
  instances_dependency    = local.all_json_dependencies_map != null ? merge(contains(keys(local.all_json_dependencies_map), "instances") ? { "instances" : local.all_json_dependencies_map.instances } : {}, contains(keys(local.all_json_dependencies_map), "private_ips") ? { "private_ips" : local.all_json_dependencies_map.private_ips } : {}) : null
  nlbs_dependency         = local.all_json_dependencies_map != null ? contains(keys(local.all_json_dependencies_map), "nlbs_private_ips") ? { "nlbs_private_ips" : local.all_json_dependencies_map.nlbs_private_ips } : null : null
}