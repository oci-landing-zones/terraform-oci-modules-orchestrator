# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  # var.compartments_dependency can be provided either as an HCL map or as an JSON file. 
  ext_dep_compartments_map = var.compartments_dependency != null ? try(var.compartments_dependency.compartments, jsondecode(file(var.compartments_dependency)).compartments, null) : null
  # compartments_dependency includes the compartments provided by the user as an external dependency (computed in ext_dep_compartments_map) and the compartments provisioned by this module itself. The line below merges these two maps together.
  compartments_dependency = merge({ for k, v in coalesce(local.ext_dep_compartments_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_compartments) > 0 ? module.oci_lz_compartments[0].compartments : {}) : k => { "id" : v.id } })

  # as var.compartments_dependency, same goes for var.network_dependency
  ext_dep_network_map = var.network_dependency != null ? try(var.network_dependency.network_resources, jsondecode(file(var.network_dependency)).network_resources, null) : null
  network_dependency = local.ext_dep_network_map != null || length(module.oci_lz_network) > 0 ? {
    "vcns" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "vcns") ? local.ext_dep_network_map["vcns"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "vcns") ? module.oci_lz_network[0].provisioned_networking_resources["vcns"] : {}) : {}) : k => { "id" : v.id } }),
    "subnets" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "subnets") ? local.ext_dep_network_map["subnets"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "subnets") ? module.oci_lz_network[0].provisioned_networking_resources["subnets"] : {}) : {}) : k => { "id" : v.id } }),
    "network_security_groups" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "network_security_groups") ? local.ext_dep_network_map["network_security_groups"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "network_security_groups") ? module.oci_lz_network[0].provisioned_networking_resources["network_security_groups"] : {}) : {}) : k => { "id" : v.id } })
    "dynamic_routing_gateways" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "dynamic_routing_gateways") ? local.ext_dep_network_map["dynamic_routing_gateways"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "dynamic_routing_gateways") ? module.oci_lz_network[0].provisioned_networking_resources["dynamic_routing_gateways"] : {}) : {}) : k => { "id" : v.id } }),
    "drg_attachments" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "drg_attachments") ? local.ext_dep_network_map["drg_attachments"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "drg_attachments") ? module.oci_lz_network[0].provisioned_networking_resources["drg_attachments"] : {}) : {}) : k => { "id" : v.id } }),
    "remote_peering_connections" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "remote_peering_connections") ? local.ext_dep_network_map["remote_peering_connections"] : {}) : {}) : k => { "id" : v.id, "region_name" : var.region } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "remote_peering_connections") ? module.oci_lz_network[0].provisioned_networking_resources["remote_peering_connections"] : {}) : {}) : k => { "id" : v.id, "region_name" : var.region } }),
    "local_peering_gateways" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "local_peering_gateways") ? local.ext_dep_network_map["local_peering_gateways"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "local_peering_gateways") ? module.oci_lz_network[0].provisioned_networking_resources["local_peering_gateways"] : {}) : {}) : k => { "id" : v.id } })
  } : null

  # var.streams_dependency
  ext_dep_streams_map = var.streams_dependency != null ? try(var.streams_dependency.streams, jsondecode(file(var.streams_dependency)).streams, null) : null
  streams_dependency  = merge({ for k, v in coalesce(local.ext_dep_streams_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => { "id" : v.id, "compartment_id" : v.compartment_id } })

  # var.topics_dependency
  ext_dep_topics_map = var.topics_dependency != null ? try(var.topics_dependency.topics, jsondecode(file(var.topics_dependency)).topics, null) : null
  topics_dependency  = merge({ for k, v in coalesce(local.ext_dep_topics_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => { "id" : v.id } })

  # var.logs_dependency
  ext_dep_service_logs_map = var.logging_dependency != null ? try(var.logging_dependency.service_logs, jsondecode(file(var.logging_dependency)).service_logs, null) : null
  ext_dep_custom_logs_map  = var.logging_dependency != null ? try(var.logging_dependency.custom_logs, jsondecode(file(var.logging_dependency)).custom_logs, null) : null
  logs_dependency          = merge({ for k, v in merge(coalesce(local.ext_dep_service_logs_map, {}), coalesce(local.ext_dep_custom_logs_map, {})) : k => { "id" : v.id, "compartment_id" : v.compartment_id } }, { for k, v in(length(module.oci_lz_logging) > 0 ? merge(coalesce(module.oci_lz_logging[0].service_logs, {}), coalesce(module.oci_lz_logging[0].custom_logs, {})) : {}) : k => { "id" : v.id, "compartment_id" : v.compartment_id } })

  # var.kms_dependency
  ext_dep_kms_map = var.kms_dependency != null ? try(var.kms_dependency.keys, jsondecode(file(var.kms_dependency)).keys, null) : null
  kms_dependency  = merge({ for k, v in coalesce(local.ext_dep_kms_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].keys : {}) : k => { "id" : v.id } })

  # var.vaults_dependency
  ext_dep_vaults_map = var.vaults_dependency != null ? try(var.vaults_dependency.vaults, jsondecode(file(var.vaults_dependency)).vaults, null) : null
  vaults_dependency  = merge({ for k, v in coalesce(local.ext_dep_vaults_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].vaults : {}) : k => { "management_endpoint" : v.management_endpoint } })

  # var.tags_dependency
  ext_dep_tags_map = var.tags_dependency != null ? try(var.tags_dependency.tags, jsondecode(file(var.tags_dependency)).tags, null) : null
  tags_dependency  = merge({ for k, v in coalesce(local.ext_dep_tags_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_tags) > 0 ? module.oci_lz_tags[0].tags : {}) : k => { "id" : v.id } })

  # var.instances_dependency
  ext_dep_instances_map = var.instances_dependency != null ? try(var.instances_dependency.instances, jsondecode(file(var.instances_dependency)).instances, null) : null
  instances_dependency  = merge({ for k, v in coalesce(local.ext_dep_instances_map, {}) : k => { "id" : v.id, "private_ip" : v.private_ip } }, { for k, v in(length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].instances : {}) : k => { "id" : v.id, "private_ip" : v.create_vnic_details[0].private_ip } }, { for k, v in(length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].secondary_vnics : {}) : k => { "id" : v.id, "private_ip" : v.private_ip_address } })

  # var.nlbs_dependency
  ext_dep_nlbs_map = var.nlbs_dependency != null ? try(var.nlbs_dependency.nlbs_private_ips, jsondecode(file(var.nlbs_dependency)).nlbs_private_ips, null) : null
  nlbs_dependency  = { for k, v in coalesce(local.ext_dep_nlbs_map, {}) : k => { "id" : v.id } }
}