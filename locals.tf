# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
    # var.compartments_dependency can be provided either as an HCL map or as an JSON file. 
    ext_dep_compartments_map = var.compartments_dependency != null ? try(var.compartments_dependency.compartments, jsondecode(file(var.compartments_dependency)).compartments, null) : null
    # compartments_dependency includes the compartments provided by the user as an external dependency (computed in ext_dep_compartments_map) and the compartments provisioned by this module itself. The line below merges these two maps together.
    compartments_dependency = merge({for k, v in coalesce(local.ext_dep_compartments_map,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_compartments) > 0 ? module.oci_lz_compartments[0].compartments : {}) : k => {"id" : v.id}})

    # as var.compartments_dependency, same goes for var.network_dependency
    ext_dep_network_map = var.network_dependency != null ? try(var.network_dependency.network_resources, jsondecode(file(var.network_dependency)).network_resources, null) : null
    network_dependency = local.ext_dep_network_map != null || length(module.oci_lz_network) > 0 ? {
        "vcns" : merge({for k, v in (local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map),"vcns") ? local.ext_dep_network_map["vcns"] : {}) : {}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].network_resources,"vcns")) ? module.oci_lz_network[0].network_resources["vcns"] : {}) : {}) : k => {"id" : v.id}}),
        "subnets" : merge({for k, v in (local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map),"subnets") ? local.ext_dep_network_map["subnets"] : {}) : {}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].network_resources,"subnets")) ? module.oci_lz_network[0].network_resources["subnets"] : {}) : {}) : k => {"id" : v.id}}),
        "network_security_groups" : merge({for k, v in (local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map),"network_security_groups") ? local.ext_dep_network_map["network_security_groups"] : {}) : {}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].network_resources,"network_security_groups")) ? module.oci_lz_network[0].network_resources["network_security_groups"] : {}) : {}) : k => {"id" : v.id}})
    } : null

    ext_dep_streams_map = var.streams_dependency != null ? try(var.streams_dependency.streams, jsondecode(file(var.streams_dependency)).streams, null) : null
    streams_dependency = merge({for k, v in coalesce(local.ext_dep_streams_map,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})

    ext_dep_topics_map = var.topics_dependency != null ? try(var.topics_dependency.topics, jsondecode(file(var.topics_dependency)).topics, null) : null
    topics_dependency  = merge({for k, v in coalesce(local.ext_dep_topics_map,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})

    ext_dep_service_logs_map = var.logging_dependency != null ? try(var.logging_dependency.service_logs, jsondecode(file(var.logging_dependency)).service_logs, null) : null
    ext_dep_custom_logs_map = var.logging_dependency != null ? try(var.logging_dependency.custom_logs, jsondecode(file(var.logging_dependency)).custom_logs, null) : null
    logs_dependency = merge({for k, v in merge(coalesce(local.ext_dep_service_logs_map,{}), coalesce(local.ext_dep_custom_logs_map,{})) : k => {"id" : v.id, "compartment_id" : v.compartment_id}}, {for k, v in (length(module.oci_lz_logging) > 0 ? merge(coalesce(module.oci_lz_logging[0].service_logs,{}), coalesce(module.oci_lz_logging[0].custom_logs,{})): {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
}