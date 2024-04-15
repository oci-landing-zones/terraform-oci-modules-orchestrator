# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
    compartments_output = length(module.oci_lz_orchestrator.iam_resources.compartments) > 0 ? {
        "compartments" : {for k, v in module.oci_lz_orchestrator.iam_resources.compartments : k => {"id" : v.id}}
    } : null
    network_output = module.oci_lz_orchestrator.network_resources != null ? {
        "network_resources" : {
            "vcns" : {for k, v in module.oci_lz_orchestrator.network_resources.vcns : k => {"id" : v.id}},
            "subnets" : {for k, v in module.oci_lz_orchestrator.network_resources.subnets : k => {"id" : v.id}},
            "network_security_groups" : {for k, v in module.oci_lz_orchestrator.network_resources.network_security_groups : k => {"id" : v.id}}
            "dynamic_routing_gateways" : {for k, v in module.oci_lz_orchestrator.network_resources.dynamic_routing_gateways : k => {"id" : v.id}}
            "drg_attachments" : {for k, v in module.oci_lz_orchestrator.network_resources.drg_attachments : k => {"id" : v.id}}
            "remote_peering_connections" : {for k, v in module.oci_lz_orchestrator.network_resources.remote_peering_connections : k => {"id" : v.id}}
            "local_peering_gateways" : {for k, v in module.oci_lz_orchestrator.network_resources.local_peering_gateways : k => {"id" : v.id}}
        }    
    } : null
    topics_output = length(module.oci_lz_orchestrator.observability_resources.notifications_topics) > 0 ? {
        "topics" : {for k, v in module.oci_lz_orchestrator.observability_resources.notifications_topics : k => {"id" : v.id}}
    } : null
    streams_output = length(module.oci_lz_orchestrator.observability_resources.streams) > 0 ? {
        "streams" : {for k, v in module.oci_lz_orchestrator.observability_resources.streams : k => {"id" : v.id}}
    } : null
    custom_logs_output = length(module.oci_lz_orchestrator.observability_resources.custom_logs) > 0 ? {
        "custom_logs" : {for k, v in module.oci_lz_orchestrator.observability_resources.custom_logs : k => {"id" : v.id, "compartment_id" : v.compartment_id}}
    } : null
    service_logs_output = length(module.oci_lz_orchestrator.observability_resources.service_logs) > 0 ? {
        "service_logs" : {for k, v in module.oci_lz_orchestrator.observability_resources.service_logs : k => {"id" : v.id, "compartment_id" : v.compartment_id}}
    } : null
    vaults_output = length(module.oci_lz_orchestrator.security_resources.vaults) > 0 ? {
        "vaults" : {for k, v in module.oci_lz_orchestrator.security_resources.vaults : k => {"management_endpoint" : v.management_endpoint}}
    } : null
    keys_output = length(module.oci_lz_orchestrator.security_resources.keys) > 0 ? {
        "keys" : {for k, v in module.oci_lz_orchestrator.security_resources.keys : k => {"id" : v.id}}
    } : null
    tags_output = length(module.oci_lz_orchestrator.governance_resources.tags) > 0 ? {
        "tags" : {for k, v in module.oci_lz_orchestrator.governance_resources.tags : k => {"id" : v.id}}
    } : null
    instances_output = length(module.oci_lz_orchestrator.compute_resources.instances) > 0 ? {
        "instances" : {for k, v in module.oci_lz_orchestrator.compute_resources.instances : k => {"id" : v.id, "private_ip" : v.create_vnic_details[0].private_ip}},
        "secondary_vnics" : {for k, v in module.oci_lz_orchestrator.compute_resources.secondary_vnics : k => {"id" : v.id, "private_ip" : v.private_ip_address}}
    } : null
    nlbs_output = length(module.oci_lz_orchestrator.nlb_resources.nlbs_private_ips) > 0 ? {
        "nlbs_private_ips" : {for k, v in module.oci_lz_orchestrator.nlb_resources.nlbs_private_ips : k => {"id" : v.private_ips[0].id}}
    } : null

    compartments_output_file_name = "compartments_output.json"
    networking_output_file_name   = "networking_output.json"
    topics_output_file_name       = "topics_output.json"
    streams_output_file_name      = "streams_output.json"
    service_logs_output_file_name = "service_logs_output.json"
    custom_logs_output_file_name  = "custom_logs_output.json"
    vaults_output_file_name       = "vaults_output.json"
    keys_output_file_name         = "keys_output.json"
    tags_output_file_name         = "tags_output.json"
    instances_output_file_name    = "instances_output.json"
    nlbs_output_file_name         = "nlbs_output.json"
}

### Writing compartments output to bucket
resource "oci_objectstorage_object" "compartments" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.compartments_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.compartments_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.compartments_output_file_name}"
}

### Writing networking output to OCI bucket
resource "oci_objectstorage_object" "networking" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.network_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.network_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.networking_output_file_name}"
}

### Writing notifications topics output to OCI bucket
resource "oci_objectstorage_object" "topics" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.topics_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.topics_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.topics_output_file_name}"
}

### Writing streams output to OCI bucket
resource "oci_objectstorage_object" "streams" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.streams_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.streams_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.streams_output_file_name}"
}

### Writing service logs output to OCI bucket
resource "oci_objectstorage_object" "service_logs" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.service_logs_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.service_logs_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.service_logs_output_file_name}"
}

### Writing custom logs output to OCI bucket
resource "oci_objectstorage_object" "custom_logs" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.custom_logs_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.custom_logs_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.custom_logs_output_file_name}"
}

### Writing vaults output to OCI bucket
resource "oci_objectstorage_object" "vaults" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.vaults_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.vaults_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.vaults_output_file_name}"
}

### Writing keys output to OCI bucket
resource "oci_objectstorage_object" "keys" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.keys_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.keys_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.keys_output_file_name}"
}

### Writing tags output to OCI bucket
resource "oci_objectstorage_object" "tags" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.tags_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.tags_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.tags_output_file_name}"
}

### Writing instances output to OCI bucket
resource "oci_objectstorage_object" "instances" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.instances_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.instances_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.instances_output_file_name}"
}

### Writing NLBs output to OCI bucket
resource "oci_objectstorage_object" "nlbs" {
  count = var.save_output && lower(var.configuration_source) == "ocibucket" && local.nlbs_output != null ? 1 : 0
  bucket    = var.oci_configuration_bucket
  content   = jsonencode(local.nlbs_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = "${var.oci_object_prefix}/${local.nlbs_output_file_name}"
}

### Writing compartments output to GitHub repository
resource "github_repository_file" "compartments" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.compartments_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.compartments_output_file_name}"
  content             = jsonencode(local.compartments_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing networking output to GitHub repository
resource "github_repository_file" "networking" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.network_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.networking_output_file_name}"
  content             = jsonencode(local.network_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing notification topics output to GitHub repository
resource "github_repository_file" "topics" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.topics_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.topics_output_file_name}"
  content             = jsonencode(local.topics_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing streams output to GitHub repository
resource "github_repository_file" "streams" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.streams_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.streams_output_file_name}"
  content             = jsonencode(local.streams_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing service logs output to GitHub repository
resource "github_repository_file" "service_logs" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.service_logs_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.service_logs_output_file_name}"
  content             = jsonencode(local.service_logs_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing custom logs output to GitHub repository
resource "github_repository_file" "custom_logs" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.custom_logs_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.custom_logs_output_file_name}"
  content             = jsonencode(local.custom_logs_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing vaults output to GitHub repository
resource "github_repository_file" "vaults" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.vaults_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.vaults_output_file_name}"
  content             = jsonencode(local.vaults_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing keys output to GitHub repository
resource "github_repository_file" "keys" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.keys_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.keys_output_file_name}"
  content             = jsonencode(local.keys_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing tags output to GitHub repository
resource "github_repository_file" "tags" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.tags_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.tags_output_file_name}"
  content             = jsonencode(local.tags_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing instances output to GitHub repository
resource "github_repository_file" "instances" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.instances_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.instances_output_file_name}"
  content             = jsonencode(local.instances_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing NLBs output to GitHub repository
resource "github_repository_file" "nlbs" {
  count = var.save_output && lower(var.configuration_source) == "github" && local.nlbs_output != null ? 1 : 0
  repository          = var.github_configuration_repo
  branch              = var.github_configuration_branch
  file                = "${var.github_file_prefix}/${local.nlbs_output_file_name}"
  content             = jsonencode(local.nlbs_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing private_ips output to GitHub repository
data "github_repository" "this" {
  count = var.save_output && lower(var.configuration_source) == "github" ? 1 : 0
  name = var.github_configuration_repo
}

locals {
  object_storage_output_string = "Files saved to OCI bucket ${coalesce(var.oci_configuration_bucket,"__void__")}: ${join(",",compact([try(oci_objectstorage_object.compartments[0].object,""),try(oci_objectstorage_object.networking[0].object,""),try(oci_objectstorage_object.topics[0].object,""),try(oci_objectstorage_object.streams[0].object,""),try(oci_objectstorage_object.service_logs[0].object,""),try(oci_objectstorage_object.custom_logs[0].object,""),try(oci_objectstorage_object.vaults[0].object,""),try(oci_objectstorage_object.keys[0].object,""),try(oci_objectstorage_object.tags[0].object,""),try(oci_objectstorage_object.instances[0].object,""),try(oci_objectstorage_object.nlbs[0].object,"")]))}"
  github_output_string = "Files saved to GitHub repository ${coalesce(var.github_configuration_repo,"__void__")}, branch ${coalesce(var.github_configuration_branch,"__void__")}: ${join(",",compact([try(github_repository_file.compartments[0].file,""),try(github_repository_file.networking[0].file,""),try(github_repository_file.topics[0].file,""),try(github_repository_file.streams[0].file,""),try(github_repository_file.service_logs[0].file,""),try(github_repository_file.custom_logs[0].file,""),try(github_repository_file.vaults[0].file,""),try(github_repository_file.keys[0].file,""),try(github_repository_file.tags[0].file,""),try(github_repository_file.instances[0].file,""),try(github_repository_file.nlbs[0].file,"")]))}"
  output_string = var.save_output ? (lower(var.configuration_source) == "ocibucket" ? local.object_storage_output_string : lower(var.configuration_source) == "github" ? local.github_output_string : "") : null
} 

output "output_string" {
  value = local.output_string
} 

output "region" {
  value = var.region
}

output "network_dependency" {
  value = module.oci_lz_orchestrator.network_dependency
}