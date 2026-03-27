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
  url_ocibucket_json_dependencies = [for element in flatten(data.oci_objectstorage_object.url_dependencies[*].content) : try(jsondecode(element), null) if length(data.oci_objectstorage_object.url_dependencies) > 0]
  url_github_json_dependencies    = [for element in flatten(data.github_repository_file.url_dependencies[*].content) : try(jsondecode(element), null) if length(data.github_repository_file.url_dependencies) > 0]
  ocibucket_json_dependencies     = [for element in flatten(data.oci_objectstorage_object.dependencies[*].content) : try(jsondecode(element), null) if length(data.oci_objectstorage_object.dependencies) > 0]
  github_json_dependencies        = [for element in flatten(data.github_repository_file.dependencies[*].content) : try(jsondecode(element), null) if length(data.github_repository_file.dependencies) > 0]
  local_file_json_dependencies    = [for element in var.local_dependency_file_paths : try(jsondecode(file(element)), null) if lower(reverse(split(".", element))[0]) == "json"]
  all_json_dependencies = concat(local.url_ocibucket_json_dependencies, local.url_github_json_dependencies, local.ocibucket_json_dependencies, local.github_json_dependencies, local.local_file_json_dependencies)

  all_json_dependencies_keys = flatten([for value in local.all_json_dependencies : keys(value) if length(local.all_json_dependencies) > 0])

  all_json_dependencies_map = { for key in local.all_json_dependencies_keys :
    key => [for config in local.all_json_dependencies : config[key] if contains(keys(config), key)][0]
  if length(local.all_json_dependencies_keys) > 0 }

  url_ocibucket_yaml_dependencies = [for element in flatten(data.oci_objectstorage_object.url_dependencies[*].content) : try(yamldecode(element), null) if length(data.oci_objectstorage_object.url_dependencies) > 0]
  url_github_yaml_dependencies    = [for element in flatten(data.github_repository_file.url_dependencies[*].content) : try(yamldecode(element), null) if length(data.github_repository_file.url_dependencies) > 0]
  ocibucket_yaml_dependencies     = [for element in flatten(data.oci_objectstorage_object.dependencies[*].content) : try(yamldecode(element), null) if length(data.oci_objectstorage_object.dependencies) > 0]
  github_yaml_dependencies        = [for element in flatten(data.github_repository_file.dependencies[*].content) : try(yamldecode(element), null) if length(data.github_repository_file.dependencies) > 0]
  local_file_yaml_dependencies    = [for element in var.local_dependency_file_paths : try(yamldecode(file(element)), null) if (lower(reverse(split(".", element))[0]) == "yaml" || lower(reverse(split(".", element))[0]) == "yml")]
  all_yaml_dependencies = concat(local.url_ocibucket_yaml_dependencies, local.url_github_yaml_dependencies, local.ocibucket_yaml_dependencies, local.github_yaml_dependencies, local.local_file_yaml_dependencies)

  all_yaml_dependencies_keys = flatten([for value in local.all_yaml_dependencies : keys(value) if length(local.all_yaml_dependencies) > 0])

  all_yaml_dependencies_map = { for key in local.all_yaml_dependencies_keys :
    key => [for config in local.all_yaml_dependencies : config[key] if contains(keys(config), key)][0]
  if length(local.all_yaml_dependencies_keys) > 0 }

  merged_dependencies = merge(local.all_json_dependencies_map, local.all_yaml_dependencies_map)

  compartments_dependency = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "compartments") ? { "compartments" : local.merged_dependencies.compartments } : null : null
  tags_dependency         = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "tags") ? { "tags" : local.merged_dependencies.tags } : null : null
  network_dependency      = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "network_resources") ? { "network_resources" : local.merged_dependencies.network_resources } : null : null
  kms_dependency          = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "keys") ? { "keys" : local.merged_dependencies.keys } : null : null
  streams_dependency      = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "streams") ? { "streams" : local.merged_dependencies.streams } : null : null
  topics_dependency       = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "topics") ? { "topics" : local.merged_dependencies.topics } : null : null
  logging_dependency      = local.merged_dependencies != null ? merge(contains(keys(local.merged_dependencies), "service_logs") ? { "service_logs" : local.merged_dependencies.service_logs } : {}, contains(keys(local.merged_dependencies), "custom_logs") ? { "custom_logs" : local.merged_dependencies.custom_logs } : {}) : null
  functions_dependency    = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "functions") ? { "functions" : local.merged_dependencies.functions } : null : null
  vaults_dependency       = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "vaults") ? { "vaults" : local.merged_dependencies.vaults } : null : null
  instances_dependency    = local.merged_dependencies != null ? merge(contains(keys(local.merged_dependencies), "instances") ? { "instances" : local.merged_dependencies.instances } : {}, contains(keys(local.merged_dependencies), "private_ips") ? { "private_ips" : local.merged_dependencies.private_ips } : {}) : null
  ocvs_dependency         = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "clusters") ? { "clusters" : local.merged_dependencies.clusters } : null : null
  nlbs_dependency         = local.merged_dependencies != null ? contains(keys(local.merged_dependencies), "nlbs_private_ips") ? { "nlbs_private_ips" : local.merged_dependencies.nlbs_private_ips } : null : null
}

