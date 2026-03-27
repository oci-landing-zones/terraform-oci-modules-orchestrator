# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
    compartments_output = length(module.oci_lz_orchestrator.iam_resources.compartments) > 0 ? {
        "compartments" : {for k, v in module.oci_lz_orchestrator.iam_resources.compartments : k => {"id" : v.id}}
    } : null
    identity_domains_output = length(module.oci_lz_orchestrator.iam_resources.identity_domains) > 0 ? {
        "identity_domains" : {for k, v in module.oci_lz_orchestrator.iam_resources.identity_domains : k => {"id" : v.id}}
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
            "drg_route_tables" : {for k, v in module.oci_lz_orchestrator.network_resources.drg_route_tables : k => {"id" : v.id}}
            "dns_resolver" : {for k, v in module.oci_lz_orchestrator.network_resources.dns_resolver : k => {"id" : v.ocid}}
            "dns_zones" : {for k, v in module.oci_lz_orchestrator.network_resources.dns_zones : k => {"id" : v.ocid}}
            "dns_views" : {for k, v in module.oci_lz_orchestrator.network_resources.dns_views : k => {"id" : v.ocid}}
            "l7_load_balancers" : {for k, v in try(module.oci_lz_orchestrator.network_resources.l7_load_balancers.l7_load_balancers, {}) : k => {"id" : v.id}}
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
    bastions_output = length(module.oci_lz_orchestrator.security_resources.bastions) > 0 ? {
        "bastions" : {for k, v in module.oci_lz_orchestrator.security_resources.bastions : k => {"id" : v.id}}
    } : null
    tags_output = length(module.oci_lz_orchestrator.governance_resources.tags) > 0 ? {
        "tags" : {for k, v in module.oci_lz_orchestrator.governance_resources.tags : k => {"id" : v.id}}
    } : null
    instances_output = length(module.oci_lz_orchestrator.compute_resources.instances) > 0 ? {
        "instances" : {for k, v in module.oci_lz_orchestrator.compute_resources.instances : k => {"id" : v.id, "private_ip" : v.create_vnic_details[0].private_ip}},
        "secondary_vnics" : {for k, v in module.oci_lz_orchestrator.compute_resources.secondary_vnics : k => {"id" : v.id, "private_ip" : v.private_ip_address}}
    } : null
    nlbs_output = length(module.oci_lz_orchestrator.nlb_resources.nlbs_private_ips) > 0 ? {
        "nlbs_private_ips" : {for k, v in module.oci_lz_orchestrator.nlb_resources.nlbs_private_ips : k => {"id" : v.private_ips[0].id}},
        "nlbs_public_ips" : {for k, v in module.oci_lz_orchestrator.nlb_resources.nlbs_public_ips : k => {"private_ip_id" : v.private_ip_id, "id" : v.id}}
    } : null
    ocvs_output = length(module.oci_lz_orchestrator.ocvs_resources.clusters) > 0 ? {
        "clusters" : { for k, v in module.oci_lz_orchestrator.ocvs_resources.clusters : k => { "id" : v.id } }
    } : null
    oke_output = length(module.oci_lz_orchestrator.oke_resources.clusters) > 0 ? {
        "oke_clusters" : {for k, v in module.oci_lz_orchestrator.oke_resources.clusters : k => {"id" : v.id}},
        "oke_node_pools" : {for k, v in module.oci_lz_orchestrator.oke_resources.node_pools : k => {"id" : v.id}},
        "oke_virtual_node_pools" : {for k, v in module.oci_lz_orchestrator.oke_resources.virtual_node_pools : k => {"id" : v.id}}
    } : null

    output_format = lower(trimspace(var.output_format))

    compartments_output_file_name     = "compartments_output.${local.output_format}"
    identity_domains_output_file_name = "identity_domains_output.${local.output_format}"
    networking_output_file_name       = "network_output.${local.output_format}"
    topics_output_file_name           = "topics_output.${local.output_format}"
    streams_output_file_name          = "streams_output.${local.output_format}"
    service_logs_output_file_name     = "service_logs_output.${local.output_format}"
    custom_logs_output_file_name      = "custom_logs_output.${local.output_format}"
    vaults_output_file_name           = "vaults_output.${local.output_format}"
    keys_output_file_name             = "keys_output.${local.output_format}"
    bastions_output_file_name         = "bastions_output.${local.output_format}"
    tags_output_file_name             = "tags_output.${local.output_format}"
    instances_output_file_name        = "instances_output.${local.output_format}"
    nlbs_output_file_name             = "nlbs_output.${local.output_format}"
    oke_output_file_name              = "oke_output.${local.output_format}"
    ocvs_output_file_name             = "ocvs_output.${local.output_format}"

    compartments_content     = local.output_format == "json" ? jsonencode(local.compartments_output) : yamlencode(local.compartments_output)
    identity_domains_content = local.output_format == "json" ? jsonencode(local.identity_domains_output) : yamlencode(local.identity_domains_output)
    networking_content       = local.output_format == "json" ? jsonencode(local.network_output) : yamlencode(local.network_output)
    topics_content           = local.output_format == "json" ? jsonencode(local.topics_output) : yamlencode(local.topics_output)
    streams_content          = local.output_format == "json" ? jsonencode(local.streams_output) : yamlencode(local.streams_output)
    service_logs_content     = local.output_format == "json" ? jsonencode(local.service_logs_output) : yamlencode(local.service_logs_output)
    custom_logs_content      = local.output_format == "json" ? jsonencode(local.custom_logs_output) : yamlencode(local.custom_logs_output)
    vaults_content           = local.output_format == "json" ? jsonencode(local.vaults_output) : yamlencode(local.vaults_output)
    keys_content             = local.output_format == "json" ? jsonencode(local.keys_output) : yamlencode(local.keys_output)
    bastions_content         = local.output_format == "json" ? jsonencode(local.bastions_output) : yamlencode(local.bastions_output)
    tags_content             = local.output_format == "json" ? jsonencode(local.tags_output) : yamlencode(local.tags_output)
    instances_content        = local.output_format == "json" ? jsonencode(local.instances_output) : yamlencode(local.instances_output)
    nlbs_content             = local.output_format == "json" ? jsonencode(local.nlbs_output) : yamlencode(local.nlbs_output)
    oke_content              = local.output_format == "json" ? jsonencode(local.oke_output) : yamlencode(local.oke_output)
    ocvs_content             = local.output_format == "json" ? jsonencode(local.ocvs_output) : yamlencode(local.ocvs_output)

  github_repository_name = var.github_configuration_repo != null ? split("/", var.github_configuration_repo)[1] : null # Use only repository name
}

### Writing compartments output to bucket
resource "oci_objectstorage_object" "compartments" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.compartments_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.compartments_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.compartments_output_file_name}" : local.compartments_output_file_name
}

### Writing identity domains output to bucket
resource "oci_objectstorage_object" "identity_domains" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.identity_domains_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.identity_domains_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.identity_domains_output_file_name}" : local.identity_domains_output_file_name
}

### Writing networking output to OCI bucket
resource "oci_objectstorage_object" "networking" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.network_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.networking_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.networking_output_file_name}" : local.networking_output_file_name
}

### Writing notifications topics output to OCI bucket
resource "oci_objectstorage_object" "topics" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.topics_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.topics_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.topics_output_file_name}" : local.topics_output_file_name
}

### Writing streams output to OCI bucket
resource "oci_objectstorage_object" "streams" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.streams_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.streams_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.streams_output_file_name}" : local.streams_output_file_name
}

### Writing service logs output to OCI bucket
resource "oci_objectstorage_object" "service_logs" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.service_logs_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.service_logs_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.service_logs_output_file_name}" : local.service_logs_output_file_name
}

### Writing custom logs output to OCI bucket
resource "oci_objectstorage_object" "custom_logs" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.custom_logs_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.custom_logs_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.custom_logs_output_file_name}" : local.custom_logs_output_file_name
}

### Writing vaults output to OCI bucket
resource "oci_objectstorage_object" "vaults" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.vaults_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.vaults_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.vaults_output_file_name}" : local.vaults_output_file_name
}

### Writing keys output to OCI bucket
resource "oci_objectstorage_object" "keys" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.keys_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.keys_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.keys_output_file_name}" : local.keys_output_file_name
}

### Writing bastions output to OCI bucket
resource "oci_objectstorage_object" "bastions" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.bastions_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.bastions_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.bastions_output_file_name}" : local.bastions_output_file_name
}

### Writing tags output to OCI bucket
resource "oci_objectstorage_object" "tags" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.tags_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.tags_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.tags_output_file_name}" : local.tags_output_file_name
}

### Writing instances output to OCI bucket
resource "oci_objectstorage_object" "instances" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.instances_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.instances_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.instances_output_file_name}" : local.instances_output_file_name
}

### Writing NLBs output to OCI bucket
resource "oci_objectstorage_object" "nlbs" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.nlbs_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.nlbs_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.nlbs_output_file_name}" : local.nlbs_output_file_name
}

### Writing OKE output to OCI bucket
resource "oci_objectstorage_object" "oke" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.oke_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = local.oke_content
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.oke_output_file_name}" : local.oke_output_file_name
}

### Writing OCVS output to OCI bucket
resource "oci_objectstorage_object" "ocvs" {
  count     = var.save_output && (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket") && local.ocvs_output != null ? 1 : 0
  bucket    = coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")
  content   = jsonencode(local.ocvs_output)
  namespace = data.oci_objectstorage_namespace.this[0].namespace
  object    = var.oci_object_prefix != null ? "${var.oci_object_prefix}/${local.ocvs_output_file_name}" : local.ocvs_output_file_name
}

# Github 
# 
# Github repository file has a bug where TF `data` and `resource` has inconsitent behaviour of handling repository name. 
# When token used for authentication is created in different organization than a target repository this results in 404 error as `owner` on github provider 
# defaults to the current user. We expect organization to be always part of repository name and use it to infer right owner. Additionally organization 
# shouldn't be part of repository in `resource github_repository_file` so we use only the repository name itself.
#
# This comment is referenced in `rms-facade/providers.tf`

### Writing compartments output to GitHub repository
resource "github_repository_file" "compartments" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.compartments_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.compartments_output_file_name}" : local.compartments_output_file_name
  content             = local.compartments_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing identity_domains output to GitHub repository
resource "github_repository_file" "identity_domains" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.identity_domains_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.identity_domains_output_file_name}" : local.identity_domains_output_file_name
  content             = local.identity_domains_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing networking output to GitHub repository
resource "github_repository_file" "networking" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.network_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.networking_output_file_name}" : local.networking_output_file_name
  content             = local.networking_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing notification topics output to GitHub repository
resource "github_repository_file" "topics" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.topics_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.topics_output_file_name}" : local.topics_output_file_name
  content             = local.topics_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing streams output to GitHub repository
resource "github_repository_file" "streams" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.streams_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.streams_output_file_name}" : local.streams_output_file_name
  content             = local.streams_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing service logs output to GitHub repository
resource "github_repository_file" "service_logs" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.service_logs_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.service_logs_output_file_name}" : local.service_logs_output_file_name
  content             = local.service_logs_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing custom logs output to GitHub repository
resource "github_repository_file" "custom_logs" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.custom_logs_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.custom_logs_output_file_name}" : local.custom_logs_output_file_name
  content             = local.custom_logs_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing vaults output to GitHub repository
resource "github_repository_file" "vaults" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.vaults_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.vaults_output_file_name}" : local.vaults_output_file_name
  content             = local.vaults_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing keys output to GitHub repository
resource "github_repository_file" "keys" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.keys_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.keys_output_file_name}" : local.keys_output_file_name
  content             = local.keys_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing bastions output to GitHub repository
resource "github_repository_file" "bastions" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.bastions_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.bastions_output_file_name}" : local.bastions_output_file_name
  content             = local.bastions_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing tags output to GitHub repository
resource "github_repository_file" "tags" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.tags_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.tags_output_file_name}" : local.tags_output_file_name
  content             = local.tags_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing instances output to GitHub repository
resource "github_repository_file" "instances" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.instances_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.instances_output_file_name}" : local.instances_output_file_name
  content             = local.instances_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing NLBs output to GitHub repository
resource "github_repository_file" "nlbs" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.nlbs_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.nlbs_output_file_name}" : local.nlbs_output_file_name
  content             = local.nlbs_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing OKE output to GitHub repository
resource "github_repository_file" "oke" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.oke_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.oke_output_file_name}" : local.oke_output_file_name
  content             = local.oke_content
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

### Writing OCVS output to GitHub repository
resource "github_repository_file" "ocvs" {
  count               = var.save_output && (lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github") && local.ocvs_output != null ? 1 : 0
  repository          = local.github_repository_name
  branch              = var.github_configuration_branch
  file                = var.github_file_prefix != null ? "${var.github_file_prefix}/${local.ocvs_output_file_name}" : local.ocvs_output_file_name
  content             = jsonencode(local.ocvs_output)
  commit_message      = "Managed by OCI Landing Zones Orchestrator."
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}

data "github_repository" "this" {
  count = var.save_output && lower(var.configuration_source) == "github" ? 1 : 0
  name  = var.github_configuration_repo
}

### Writing compartments output to file
resource "local_file" "compartments" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.compartments_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.compartments_output_file_name}"
  content  = local.compartments_content
}

### Writing identity_domains output to file
resource "local_file" "identity_domains" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.identity_domains_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.identity_domains_output_file_name}"
  content  = local.identity_domains_content
}

### Writing networking output to file
resource "local_file" "networking" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.network_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.networking_output_file_name}"
  content  = local.networking_content
}

### Writing notification topics output to file
resource "local_file" "topics" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.topics_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.topics_output_file_name}"
  content  = local.topics_content
}

### Writing streams output to file
resource "local_file" "streams" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.streams_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.streams_output_file_name}"
  content  = local.streams_content
}

### Writing service logs output to file
resource "local_file" "service_logs" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.service_logs_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.service_logs_output_file_name}"
  content  = local.service_logs_content
}

### Writing custom logs output to file
resource "local_file" "custom_logs" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.custom_logs_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.custom_logs_output_file_name}"
  content  = local.custom_logs_content
}

### Writing vaults output to file
resource "local_file" "vaults" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.vaults_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.vaults_output_file_name}"
  content  = local.vaults_content
}

### Writing keys output to file
resource "local_file" "keys" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.keys_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.keys_output_file_name}"
  content  = local.keys_content
}  

### Writing bastions output file
resource "local_file" "bastions" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.bastions_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.bastions_output_file_name}"
  content  = local.bastions_content
}

### Writing tags output to file
resource "local_file" "tags" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.tags_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.tags_output_file_name}"
  content  = local.tags_content
}

### Writing instances output to file
resource "local_file" "instances" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.instances_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.instances_output_file_name}"
  content  = local.instances_content
}

### Writing NLBs output to file
resource "local_file" "nlbs" {
  count    = var.save_output && lower(var.configuration_source) == "file" && local.nlbs_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.nlbs_output_file_name}"
  content  = local.nlbs_content
}

### Writing OKE output to file
resource "local_file" "oke" {
  count = var.save_output && lower(var.configuration_source) == "file" && local.oke_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.oke_output_file_name}"
  content  = local.oke_content
}

### Writing OCVS output to file
resource "local_file" "ocvs" {
  count = var.save_output && lower(var.configuration_source) == "file" && local.ocvs_output != null ? 1 : 0
  filename = "${coalesce(var.output_folder_path,path.module)}/${local.ocvs_output_file_name}"
  content  = local.ocvs_content
}

locals {
  object_storage_output_string = "Files saved to OCI bucket ${coalesce(var.oci_configuration_bucket, var.url_dependency_source_oci_bucket, "__void__")}: ${join(",", compact([try(oci_objectstorage_object.compartments[0].object, ""), try(oci_objectstorage_object.identity_domains[0].object, ""), try(oci_objectstorage_object.networking[0].object, ""), try(oci_objectstorage_object.topics[0].object, ""), try(oci_objectstorage_object.streams[0].object, ""), try(oci_objectstorage_object.service_logs[0].object, ""), try(oci_objectstorage_object.custom_logs[0].object, ""), try(oci_objectstorage_object.vaults[0].object, ""), try(oci_objectstorage_object.keys[0].object, ""), try(oci_objectstorage_object.bastions[0].object, ""), try(oci_objectstorage_object.tags[0].object, ""), try(oci_objectstorage_object.instances[0].object, ""), try(oci_objectstorage_object.nlbs[0].object, ""), try(oci_objectstorage_object.oke[0].object, ""), try(oci_objectstorage_object.ocvs[0].object, "")]))}"
  github_output_string         = "Files saved to GitHub repository ${coalesce(var.github_configuration_repo, "__void__")}, branch ${coalesce(var.github_configuration_branch, "__void__")}: ${join(",", compact([try(github_repository_file.compartments[0].file, ""), try(github_repository_file.identity_domains[0].file, ""), try(github_repository_file.networking[0].file, ""), try(github_repository_file.topics[0].file, ""), try(github_repository_file.streams[0].file, ""), try(github_repository_file.service_logs[0].file, ""), try(github_repository_file.custom_logs[0].file, ""), try(github_repository_file.vaults[0].file, ""), try(github_repository_file.keys[0].file, ""), try(github_repository_file.bastions[0].file, ""), try(github_repository_file.tags[0].file, ""), try(github_repository_file.instances[0].file, ""), try(github_repository_file.nlbs[0].file, ""), try(github_repository_file.oke[0].file, ""), try(github_repository_file.ocvs[0].file, "")]))}"
  local_file_output_string     = "Files saved to local file system: ${join(",", compact([try(local_file.compartments[0].filename, ""), try(local_file.identity_domains[0].filename, ""), try(local_file.networking[0].filename, ""), try(local_file.topics[0].filename, ""), try(local_file.streams[0].filename, ""), try(local_file.service_logs[0].filename, ""), try(local_file.custom_logs[0].filename, ""), try(local_file.vaults[0].filename, ""), try(local_file.keys[0].filename, ""), try(local_file.bastions[0].filename, ""), try(local_file.tags[0].filename, ""), try(local_file.instances[0].filename, ""), try(local_file.nlbs[0].filename, ""), try(local_file.oke[0].filename, ""), try(local_file.ocvs[0].filename, "")]))}"
  output_string                = var.save_output ? (lower(var.configuration_source) == "ocibucket" || lower(var.url_dependency_source) == "ocibucket" ? local.object_storage_output_string : lower(var.configuration_source) == "github" || lower(var.url_dependency_source) == "github" ? local.github_output_string : lower(var.configuration_source) == "file" ? local.local_file_output_string : "") : null
}

output "output_string" {
  value = local.output_string
}

output "region" {
  value = var.region
}
