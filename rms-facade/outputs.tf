# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "this" {
  count = var.save_output && lower(var.output_location) == "ocibucket" ? 1 : 0
  compartment_id = var.tenancy_ocid
}

locals {
    compartments_output = length(module.oci_orchestrator_http_facade.provisioned_identity_resources.compartments) > 0 ? {
        "compartments" : {for k, v in module.oci_orchestrator_http_facade.provisioned_identity_resources.compartments : k => {"id" : v.id}}
    } : null
    networking_output = module.oci_orchestrator_http_facade.provisioned_networking_resources != null ? {
        "provisioned_networking_resources" : {
            "vcns" : {for k, v in module.oci_orchestrator_http_facade.provisioned_networking_resources.vcns : k => {"id" : v.id}},
            "subnets" : {for k, v in module.oci_orchestrator_http_facade.provisioned_networking_resources.subnets : k => {"id" : v.id}},
            "network_security_groups" : {for k, v in module.oci_orchestrator_http_facade.provisioned_networking_resources.network_security_groups : k => {"id" : v.id}}
        }    
    } : null
    topics_output = length(module.oci_orchestrator_http_facade.provisioned_observability_resources.notifications_topics) > 0 ? {
        "topics" : {for k, v in module.oci_orchestrator_http_facade.provisioned_observability_resources.notifications_topics : k => {"id" : v.id}}
    } : null
    streams_output = length(module.oci_orchestrator_http_facade.provisioned_observability_resources.streams) > 0 ? {
        "topics" : {for k, v in module.oci_orchestrator_http_facade.provisioned_observability_resources.streams : k => {"id" : v.id}}
    } : null

    compartments_output_file_name = "compartments_output.json"
    networking_output_file_name   = "networking_output.json"
    topics_output_file_name       = "topics_output.json"
    streams_output_file_name      = "streams_output.json"
}

### Writing compartments output to bucket
resource "oci_objectstorage_object" "compartments" {
  count = var.save_output && lower(var.output_location) == "ocibucket" && local.compartments_output != null ? 1 : 0
  bucket    = var.oci_bucket_name
  content   = jsonencode(local.compartments_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.compartments_output_file_name}"
}

### Writing networking output to OCI bucket
resource "oci_objectstorage_object" "networking" {
  count = var.save_output && lower(var.output_location) == "ocibucket" && local.networking_output != null ? 1 : 0
  bucket    = var.oci_bucket_name
  content   = jsonencode(local.networking_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.networking_output_file_name}"
}

### Writing notifications topics output to OCI bucket
resource "oci_objectstorage_object" "topics" {
  count = var.save_output && lower(var.output_location) == "ocibucket" && local.topics_output != null ? 1 : 0
  bucket    = var.oci_bucket_name
  content   = jsonencode(local.topics_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.topics_output_file_name}"
}

### Writing streams output to OCI bucket
resource "oci_objectstorage_object" "streams" {
  count = var.save_output && lower(var.output_location) == "ocibucket" && local.streams_output != null ? 1 : 0
  bucket    = var.oci_bucket_name
  content   = jsonencode(local.streams_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.streams_output_file_name}"
}

### Writing compartments output to GitHub repository
resource "github_repository_file" "compartments" {
  count = var.save_output && lower(var.output_location) == "github" && local.compartments_output != null ? 1 : 0
  repository          = var.github_repository_name
  branch              = var.github_branch_name
  file                = "${var.github_file_prefix}/${local.compartments_output_file_name}"
  content             = jsonencode(local.compartments_output)
  commit_message      = "Managed by OCI Landing Zone modules orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing networking output to GitHub repository
resource "github_repository_file" "networking" {
  count = var.save_output && lower(var.output_location) == "github" && local.networking_output != null ? 1 : 0
  repository          = var.github_repository_name
  branch              = var.github_branch_name
  file                = "${var.github_file_prefix}/${local.networking_output_file_name}"
  content             = jsonencode(local.networking_output)
  commit_message      = "Managed by OCI Landing Zone modules orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing notification topics output to GitHub repository
resource "github_repository_file" "topics" {
  count = var.save_output && lower(var.output_location) == "github" && local.topics_output != null ? 1 : 0
  repository          = var.github_repository_name
  branch              = var.github_branch_name
  file                = "${var.github_file_prefix}/${local.topics_output_file_name}"
  content             = jsonencode(local.topics_output)
  commit_message      = "Managed by OCI Landing Zone modules orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing streams output to GitHub repository
resource "github_repository_file" "streams" {
  count = var.save_output && lower(var.output_location) == "github" && local.streams_output != null ? 1 : 0
  repository          = var.github_repository_name
  branch              = var.github_branch_name
  file                = "${var.github_file_prefix}/${local.streams_output_file_name}"
  content             = jsonencode(local.streams_output)
  commit_message      = "Managed by OCI Landing Zone modules orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

data "github_repository" "this" {
  count = var.save_output && lower(var.output_location) == "github" ? 1 : 0
  name = var.github_repository_name
}

output "compartments_output" {
  value = length(oci_objectstorage_object.compartments) > 0 ? "Bucket: '${oci_objectstorage_object.compartments[0].bucket}', File: '${var.oci_object_prefix}/${local.compartments_output_file_name}'" : length(github_repository_file.compartments) > 0 ? "${replace(data.github_repository.this[0].html_url,"https://github.com/","https://raw.githubusercontent.com/")}/${var.github_branch_name}/${var.github_file_prefix}/${local.compartments_output_file_name}" : null
} 

output "networking_output" {
  value = length(oci_objectstorage_object.networking) > 0 ? "Bucket: '${oci_objectstorage_object.networking[0].bucket}', File: '${var.oci_object_prefix}/${local.networking_output_file_name}'" : length(github_repository_file.networking) > 0 ? "${replace(data.github_repository.this[0].html_url,"https://github.com/","https://raw.githubusercontent.com/")}/${var.github_branch_name}/${var.github_file_prefix}/${local.networking_output_file_name}" : null
} 

output "topics_output" {
  value = length(oci_objectstorage_object.topics) > 0 ? "Bucket: '${oci_objectstorage_object.topics[0].bucket}', File: '${var.oci_object_prefix}/${local.topics_output_file_name}'" : length(github_repository_file.topics) > 0 ? "${replace(data.github_repository.this[0].html_url,"https://github.com/","https://raw.githubusercontent.com/")}/${var.github_branch_name}/${var.github_file_prefix}/${local.topics_output_file_name}" : null
} 

output "streams_output" {
  value = length(oci_objectstorage_object.streams) > 0 ? "Bucket: '${oci_objectstorage_object.streams[0].bucket}', File: '${var.oci_object_prefix}/${local.streams_output_file_name}'" : length(github_repository_file.streams) > 0 ? "${replace(data.github_repository.this[0].html_url,"https://github.com/","https://raw.githubusercontent.com/")}/${var.github_branch_name}/${var.github_file_prefix}/${local.streams_output_file_name}" : null
} 

# output "provisioned_identity_resources" {
#   description = "Provisioned identity resources"
#   value       = length(module.oci_orchestrator_http_facade.provisioned_identity_resources) > 0 ? module.oci_orchestrator_http_facade.provisioned_identity_resources : null
# }

# output "provisioned_networking_resources" {
#   description = "Provisioned networking resources"
#   value       = module.oci_orchestrator_http_facade.provisioned_networking_resources
# }

# output "provisioned_streaming_resources" {
#   value = module.oci_orchestrator_http_facade.provisioned_streaming_resources
# }

output "region" {
  value = var.region
}

# output "githubreadtest" {
#   value = data.github_repository_file.readtest.content
# }

# output "githubrepo" {
#   value = local.github_repo_from_url
# }

# output "githubbranch" {
#   value = local.github_branch_from_url
# }

# output "githubfile" {
#   value = local.github_file_from_url
# }