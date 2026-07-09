# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  # var.compartments_dependency can be provided either as an HCL map or as an JSON file. 
  ext_dep_compartments_map = var.compartments_dependency != null ? try(var.compartments_dependency.compartments, jsondecode(file(var.compartments_dependency)).compartments, null) : null
  # compartments_dependency includes the compartments provided by the user as an external dependency (computed in ext_dep_compartments_map) and the compartments provisioned by this module itself. The line below merges these two maps together.
  compartments_dependency = merge({ for k, v in coalesce(local.ext_dep_compartments_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_compartments) > 0 ? module.oci_lz_compartments[0].compartments : {}) : k => { "id" : v.id } })

  # var.identity_domains_dependency can be provided either as an HCL map or as a JSON file.
  ext_dep_identity_domains_map = var.identity_domains_dependency != null ? try(var.identity_domains_dependency.identity_domains, jsondecode(file(var.identity_domains_dependency)).identity_domains, null) : null

  # as var.compartments_dependency, same goes for var.network_dependency
  ext_dep_network_map = var.network_dependency != null ? try(var.network_dependency.network_resources, jsondecode(file(var.network_dependency)).network_resources, null) : null
  provisioned_route_tables_dependency_map = length(module.oci_lz_network) > 0 ? {
    for k, v in merge(
      try(module.oci_lz_network[0].provisioned_networking_resources.default_route_tables.igw_natgw_specific_default_rts_attachable_to_igw_natgw_sgw_lpg_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.default_route_tables.sgw_specific_default_rts_attachable_to_sgw_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.default_route_tables.lpg_specific_default_rts_attachable_to_lpg_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.default_route_tables.drga_specific_default_rts_attachable_to_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.default_route_tables.non_gw_specific_remaining_default_rts_attachable_to_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.route_tables.igw_natgw_specific_rts_attachable_to_igw_natgw_sgw_lpg_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.route_tables.sgw_specific_rts_attachable_to_sgw_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.route_tables.lpg_specific_rts_attachable_to_lpg_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.route_tables.drga_specific_rts_attachable_to_drga_subnet, {}),
      try(module.oci_lz_network[0].provisioned_networking_resources.route_tables.non_gw_specific_remaining_rts_attachable_to_drga_subnet, {})
    ) : k => { "id" : v.id }
  } : {}

  network_dependency = local.ext_dep_network_map != null || length(module.oci_lz_network) > 0 ? {
    "vcns" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "vcns") ? local.ext_dep_network_map["vcns"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "vcns") ? module.oci_lz_network[0].provisioned_networking_resources["vcns"] : {}) : {}) : k => { "id" : v.id } }),
    "subnets" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "subnets") ? local.ext_dep_network_map["subnets"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "subnets") ? module.oci_lz_network[0].provisioned_networking_resources["subnets"] : {}) : {}) : k => { "id" : v.id } }),
    "network_security_groups" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "network_security_groups") ? local.ext_dep_network_map["network_security_groups"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "network_security_groups") ? module.oci_lz_network[0].provisioned_networking_resources["network_security_groups"] : {}) : {}) : k => { "id" : v.id } })
    "route_tables" : merge({ for k, v in try(local.ext_dep_network_map.route_tables, {}) : k => { "id" : v.id } }, local.provisioned_route_tables_dependency_map)
    "dynamic_routing_gateways" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "dynamic_routing_gateways") ? local.ext_dep_network_map["dynamic_routing_gateways"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "dynamic_routing_gateways") ? module.oci_lz_network[0].provisioned_networking_resources["dynamic_routing_gateways"] : {}) : {}) : k => { "id" : v.id } }),
    "drg_attachments" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "drg_attachments") ? local.ext_dep_network_map["drg_attachments"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "drg_attachments") ? module.oci_lz_network[0].provisioned_networking_resources["drg_attachments"] : {}) : {}) : k => { "id" : v.id } }),
    # Networking module v0.8.2 adds RPC region_name output; keep it for cross-region RPC dependencies and fall back to var.region for older dependency files.
    "remote_peering_connections" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "remote_peering_connections") ? local.ext_dep_network_map["remote_peering_connections"] : {}) : {}) : k => { "id" : v.id, "region_name" : try(v.region_name, var.region) } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "remote_peering_connections") ? module.oci_lz_network[0].provisioned_networking_resources["remote_peering_connections"] : {}) : {}) : k => { "id" : v.id, "region_name" : try(v.region_name, var.region) } }),
    "local_peering_gateways" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "local_peering_gateways") ? local.ext_dep_network_map["local_peering_gateways"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "local_peering_gateways") ? module.oci_lz_network[0].provisioned_networking_resources["local_peering_gateways"] : {}) : {}) : k => { "id" : v.id } })
    "l7_load_balancers" : merge({ for k, v in try(local.ext_dep_network_map["l7_load_balancers"]["l7_load_balancers"], local.ext_dep_network_map["l7_load_balancers"], {}) : k => { "id" : v.id } }, { for k, v in try(module.oci_lz_network[0].provisioned_networking_resources["l7_load_balancers"]["l7_load_balancers"], {}) : k => { "id" : v.id } })
    "dns_private_views" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "dns_private_views") ? local.ext_dep_network_map["dns_private_views"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "dns_views") ? module.oci_lz_network[0].provisioned_networking_resources["dns_views"] : {}) : {}) : k => { "id" : v.id } }),
    "public_ips" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "public_ips") ? local.ext_dep_network_map["public_ips"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "public_ips") ? module.oci_lz_network[0].provisioned_networking_resources["public_ips"] : {}) : {}) : k => { "id" : v.id } })
  } : null

  # OCVS v1.1.0 expects resource-specific attributes instead of canonical { id } dependency entries.
  ocvs_network_dependency_attributes = {
    network_security_groups = [
      "nsx_edge_uplink_1_nsg_id",
      "nsx_edge_uplink_2_nsg_id",
      "nsx_vtep_nsg_id",
      "nsx_edge_vtep_nsg_id",
      "vmotion_nsg_id",
      "vsan_nsg_id",
      "vsphere_nsg_id",
      "hcx_nsg_id",
      "replication_nsg_id",
      "provisioning_nsg_id"
    ]
    route_tables = [
      "nsx_edge_uplink_1_rt_id",
      "nsx_edge_uplink_2_rt_id",
      "nsx_vtep_rt_id",
      "nsx_edge_vtep_rt_id",
      "vmotion_rt_id",
      "vsan_rt_id",
      "vsphere_rt_id",
      "hcx_rt_id",
      "replication_rt_id",
      "provisioning_rt_id"
    ]
  }
  ocvs_network_dependency = local.network_dependency != null ? merge(local.network_dependency, {
    for dependency_type, attributes in local.ocvs_network_dependency_attributes : dependency_type => {
      for key, dependency in try(local.network_dependency[dependency_type], {}) : key => {
        for attribute in attributes : attribute => dependency.id
      }
    }
  }) : null

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

  # var.subscription_dependency
  ext_dep_subscriptions_map = var.subscription_dependency != null ? try(var.subscription_dependency.subscriptions, jsondecode(file(var.subscription_dependency)).subscriptions, null) : null
  subscription_dependency   = { for k, v in coalesce(local.ext_dep_subscriptions_map, {}) : k => { "id" : v.id } }

  # var.vaults_dependency
  ext_dep_vaults_map = var.vaults_dependency != null ? try(var.vaults_dependency.vaults, jsondecode(file(var.vaults_dependency)).vaults, null) : null
  vaults_dependency  = merge({ for k, v in coalesce(local.ext_dep_vaults_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].vaults : {}) : k => { "id" : v.id, "management_endpoint" : v.management_endpoint } })

  # var.tags_dependency
  ext_dep_tags_map = var.tags_dependency != null ? try(var.tags_dependency.tags, jsondecode(file(var.tags_dependency)).tags, null) : null
  tags_dependency  = merge({ for k, v in coalesce(local.ext_dep_tags_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_tags) > 0 ? module.oci_lz_tags[0].tags : {}) : k => { "id" : v.id } })

  # var.instances_dependency
  ext_dep_instances_map = var.instances_dependency != null ? try(var.instances_dependency.instances, jsondecode(file(var.instances_dependency)).instances, null) : null
  instances_dependency  = merge({ for k, v in coalesce(local.ext_dep_instances_map, {}) : k => { "id" : v.id, "private_ip" : v.private_ip } }, { for k, v in(length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].instances : {}) : k => { "id" : v.id, "private_ip" : v.create_vnic_details[0].private_ip } }, { for k, v in(length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].secondary_vnics : {}) : k => { "id" : v.id, "private_ip" : v.private_ip_address } })

  # var.ocvs_dependency
  ext_dep_ocvs_map = var.ocvs_dependency != null ? try(var.ocvs_dependency.clusters, jsondecode(file(var.ocvs_dependency)).clusters, null) : null
  ocvs_dependency  = merge({ for k, v in coalesce(local.ext_dep_ocvs_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_ocvs) > 0 ? module.oci_lz_ocvs[0].clusters : {}) : k => { "id" : v.id } })

  # var.databases_dependency
  ext_dep_container_databases_map = var.databases_dependency != null ? try(var.databases_dependency.container_databases, jsondecode(file(var.databases_dependency)).container_databases, null) : null
  databases_dependency            = local.ext_dep_container_databases_map != null ? { "container_databases" : { for k, v in local.ext_dep_container_databases_map : k => { "id" : v.id } } } : null

  # var.exadata_database_dependency can be provided either as a module-native object or as a cloud_exadata_database_output.json file.
  exadata_database_dependency = var.exadata_database_dependency != null ? try(jsondecode(file(var.exadata_database_dependency)), var.exadata_database_dependency, null) : null

  # var.recovery_service_dependency can be provided as a module-native object, a direct protection policy map, or an autonomous_recovery_service_output.json file.
  ext_dep_recovery_service_protection_policies = var.recovery_service_dependency != null ? try(
    var.recovery_service_dependency.protection_policies,
    jsondecode(file(var.recovery_service_dependency)).protection_policies,
    var.recovery_service_dependency,
    null
  ) : null
  recovery_service_dependency = {
    protection_policies = merge(
      coalesce(local.ext_dep_recovery_service_protection_policies, {}),
      length(module.oci_lz_autonomous_recovery_service) > 0 ? module.oci_lz_autonomous_recovery_service[0].autonomous_recovery_service_dependency.protection_policies : {}
    )
  }

  # var.nlbs_dependency
  ext_dep_nlbs_map = var.nlbs_dependency != null ? try(var.nlbs_dependency.nlbs_private_ips, jsondecode(file(var.nlbs_dependency)).nlbs_private_ips, null) : null
  nlbs_dependency  = { for k, v in coalesce(local.ext_dep_nlbs_map, {}) : k => { "id" : v.id } }
}
