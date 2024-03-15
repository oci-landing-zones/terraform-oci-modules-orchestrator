# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_object" "dependencies" {
  count = lower(var.configuration_source) == "ocibucket" && var.oci_configuration_bucket != null && var.oci_dependency_objects != null ? length(var.oci_dependency_objects) : 0
  bucket    = var.oci_configuration_bucket
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_dependency_objects[count.index]
}

data "github_repository_file" "dependencies" {
  count = lower(var.configuration_source) == "github" && var.github_dependency_files != null ? length(var.github_dependency_files) : 0
  repository = var.github_configuration_repo
  branch     = var.github_configuration_branch
  file       = var.github_dependency_files[count.index]
}

data "http" "dependencies" {
  count = var.dependency_files_urls != null ? length(var.dependency_files_urls) : 0
  url = var.dependency_files_urls[count.index]
  request_headers = {
    Accept = "application/json"
  }
}

# locals {
#   github_repo_from_url   = [for url in var.dependency_files_urls : regex("^https://raw.githubusercontent.com/andrecorreaneto/(.*)/.*$",url)[0]]
#   github_branch_from_url = [for url in var.dependency_files_urls : regex("^https://raw.githubusercontent.com/andrecorreaneto/.*/(.*)/.*$",url)[0]]
#   github_file_from_url   = [for url in var.dependency_files_urls : regex("^https://raw.githubusercontent.com/andrecorreaneto/.*/.*/(.*)$",url)[0]]
# }

# data "github_repository_file" "readtest" {
#   repository          = "oci-landing-zone-configuration"
#   branch              = "test"
#   file                = "rms-iam/output/compartments_output.json"
# }

locals {
  url_json_dependency_files = data.http.dependencies != null ? length(data.http.dependencies) > 0 ? [
    for element in flatten(data.http.dependencies[*].body) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : [] : []

  ocibucket_json_dependency_files = data.oci_objectstorage_object.dependencies != null ? length(data.oci_objectstorage_object.dependencies) > 0 ? [
    for element in flatten(data.oci_objectstorage_object.dependencies[*].content) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : [] : []

  github_json_dependency_files = data.github_repository_file.dependencies != null ? length(data.github_repository_file.dependencies) > 0 ? [
    for element in flatten(data.github_repository_file.dependencies[*].content) : jsondecode(element) if try(jsondecode(element), null) != null
  ] : [] : []

  all_json_dependency_files = concat(local.url_json_dependency_files, local.ocibucket_json_dependency_files, local.github_json_dependency_files)
  
  all_json_dependency_l1_keys = local.all_json_dependency_files != null ? length(local.all_json_dependency_files) > 0 ? flatten([
    for value in local.all_json_dependency_files : keys(value) if value != null
  ]) : null : null

  merged_dependency_files = local.all_json_dependency_l1_keys != null ? length(local.all_json_dependency_l1_keys) > 0 ? {
    for key in local.all_json_dependency_l1_keys : key => [
      for config in local.all_json_dependency_files : config[key] if contains(keys(config), key) && config != null
    ][0]
  } : null : null

  compartments_dependency = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "compartments") ? {"compartments" : local.merged_dependency_files.compartments}: null : null
  tags_dependency         = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "tags") ? {"tags" : local.merged_dependency_files.tags} : null : null
  network_dependency      = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "network_resources") ? {"network_resources" : local.merged_dependency_files.network_resources} : null : null
  kms_dependency          = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "keys") ? {"keys" : local.merged_dependency_files.keys} : null : null
  streams_dependency      = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "streams") ? {"streams" : local.merged_dependency_files.streams} : null : null
  topics_dependency       = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "topics") ? {"topics" : local.merged_dependency_files.topics} : null : null
  logging_dependency      = local.merged_dependency_files != null ? merge(contains(keys(local.merged_dependency_files), "service_logs") ? {"service_logs" : local.merged_dependency_files.service_logs} : {}, contains(keys(local.merged_dependency_files), "custom_logs") ? {"custom_logs" : local.merged_dependency_files.custom_logs} : {}) : null
  functions_dependency    = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "functions") ? {"functions" : local.merged_dependency_files.functions} : null : null
  vaults_dependency       = local.merged_dependency_files != null ? contains(keys(local.merged_dependency_files), "vaults") ? {"vaults" : local.merged_dependency_files.vaults} : null : null
}