# Copyright (c) 2026 Oracle and/or its affiliates.
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
  network_dependency = local.ext_dep_network_map != null || length(module.oci_lz_network) > 0 ? {
    "vcns" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "vcns") ? local.ext_dep_network_map["vcns"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "vcns") ? module.oci_lz_network[0].provisioned_networking_resources["vcns"] : {}) : {}) : k => { "id" : v.id } }),
    "subnets" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "subnets") ? local.ext_dep_network_map["subnets"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "subnets") ? module.oci_lz_network[0].provisioned_networking_resources["subnets"] : {}) : {}) : k => { "id" : v.id } }),
    "network_security_groups" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "network_security_groups") ? local.ext_dep_network_map["network_security_groups"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "network_security_groups") ? module.oci_lz_network[0].provisioned_networking_resources["network_security_groups"] : {}) : {}) : k => { "id" : v.id } })
    "dynamic_routing_gateways" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "dynamic_routing_gateways") ? local.ext_dep_network_map["dynamic_routing_gateways"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "dynamic_routing_gateways") ? module.oci_lz_network[0].provisioned_networking_resources["dynamic_routing_gateways"] : {}) : {}) : k => { "id" : v.id } }),
    "drg_attachments" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "drg_attachments") ? local.ext_dep_network_map["drg_attachments"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "drg_attachments") ? module.oci_lz_network[0].provisioned_networking_resources["drg_attachments"] : {}) : {}) : k => { "id" : v.id } }),
    # Networking module v0.8.2 adds RPC region_name output; keep it for cross-region RPC dependencies and fall back to var.region for older dependency files.
    "remote_peering_connections" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "remote_peering_connections") ? local.ext_dep_network_map["remote_peering_connections"] : {}) : {}) : k => { "id" : v.id, "region_name" : try(v.region_name, var.region) } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "remote_peering_connections") ? module.oci_lz_network[0].provisioned_networking_resources["remote_peering_connections"] : {}) : {}) : k => { "id" : v.id, "region_name" : try(v.region_name, var.region) } }),
    "local_peering_gateways" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "local_peering_gateways") ? local.ext_dep_network_map["local_peering_gateways"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "local_peering_gateways") ? module.oci_lz_network[0].provisioned_networking_resources["local_peering_gateways"] : {}) : {}) : k => { "id" : v.id } })
    "l7_load_balancers" : merge({ for k, v in try(local.ext_dep_network_map["l7_load_balancers"]["l7_load_balancers"], local.ext_dep_network_map["l7_load_balancers"], {}) : k => { "id" : v.id } }, { for k, v in try(module.oci_lz_network[0].provisioned_networking_resources["l7_load_balancers"]["l7_load_balancers"], {}) : k => { "id" : v.id } })
    "dns_private_views" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "dns_private_views") ? local.ext_dep_network_map["dns_private_views"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "dns_views") ? module.oci_lz_network[0].provisioned_networking_resources["dns_views"] : {}) : {}) : k => { "id" : v.id } }),
    "public_ips" : merge({ for k, v in(local.ext_dep_network_map != null ? (contains(keys(local.ext_dep_network_map), "public_ips") ? local.ext_dep_network_map["public_ips"] : {}) : {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_network) > 0 ? (contains(keys(module.oci_lz_network[0].provisioned_networking_resources), "public_ips") ? module.oci_lz_network[0].provisioned_networking_resources["public_ips"] : {}) : {}) : k => { "id" : v.id } })
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

  # var.subscription_dependency
  ext_dep_subscriptions_map = var.subscription_dependency != null ? try(var.subscription_dependency.subscriptions, jsondecode(file(var.subscription_dependency)).subscriptions, null) : null
  subscription_dependency   = { for k, v in coalesce(local.ext_dep_subscriptions_map, {}) : k => { "id" : v.id } }

  # var.vaults_dependency
  ext_dep_vaults_map = var.vaults_dependency != null ? try(var.vaults_dependency.vaults, jsondecode(file(var.vaults_dependency)).vaults, null) : null
  vaults_dependency  = merge({ for k, v in coalesce(local.ext_dep_vaults_map, {}) : k => { "id" : v.id } }, { for k, v in(length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].vaults : {}) : k => { "management_endpoint" : v.management_endpoint } })

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

  # var.recovery_service_dependency
  ext_dep_recovery_service_protection_policies_map = var.recovery_service_dependency != null ? try(var.recovery_service_dependency.protection_policies, jsondecode(file(var.recovery_service_dependency)).protection_policies, null) : null
  ext_dep_recovery_service_subnets_map             = var.recovery_service_dependency != null ? try(var.recovery_service_dependency.recovery_service_subnets, jsondecode(file(var.recovery_service_dependency)).recovery_service_subnets, null) : null
  recovery_service_dependency = local.ext_dep_recovery_service_protection_policies_map != null || local.ext_dep_recovery_service_subnets_map != null || length(module.oci_lz_autonomous_recovery_service) > 0 ? {
    "protection_policies" : merge(
      { for k, v in coalesce(local.ext_dep_recovery_service_protection_policies_map, {}) : k => { "id" : v.id } },
      { for k, v in(length(module.oci_lz_autonomous_recovery_service) > 0 ? module.oci_lz_autonomous_recovery_service[0].protection_policies : {}) : k => { "id" : v.id } }
    )
    "recovery_service_subnets" : merge(
      { for k, v in coalesce(local.ext_dep_recovery_service_subnets_map, {}) : k => { "id" : v.id } },
      { for k, v in(length(module.oci_lz_autonomous_recovery_service) > 0 ? module.oci_lz_autonomous_recovery_service[0].recovery_service_subnets : {}) : k => { "id" : v.id } }
    )
  } : null

  # var.azure_oracle_database_dependency
  ext_dep_azure_oracle_database_map = var.azure_oracle_database_dependency != null ? try(var.azure_oracle_database_dependency.azure_oracle_database_resources, jsondecode(file(var.azure_oracle_database_dependency)).azure_oracle_database_resources, var.azure_oracle_database_dependency, jsondecode(file(var.azure_oracle_database_dependency)), null) : null
  azure_oracle_database_input_dependency = local.ext_dep_azure_oracle_database_map != null || length(module.azure_lz_oracle_vmc_network) > 0 || length(module.azure_lz_oracle_exadata_infrastructure) > 0 ? {
    "azure_vmc_networks" : merge(
      { for k, v in try(local.ext_dep_azure_oracle_database_map.azure_vmc_networks, {}) : k => {
        "id"                  = v.id
        "name"                = try(v.name, k)
        "resource_group_name" = try(v.resource_group_name, null)
        "subnets"             = { for subnet_key, subnet in try(v.subnets, {}) : subnet_key => { "id" = subnet.id, "name" = try(subnet.name, subnet_key) } }
      } },
      { for k, v in module.azure_lz_oracle_vmc_network : k => {
        "id"                  = v.resource_id
        "name"                = try(v.resource.name, k)
        "resource_group_name" = v.resource_group_name
        "subnets"             = { for subnet_key, subnet in try(v.subnets, {}) : subnet_key => { "id" = try(subnet.resource_id, subnet.id), "name" = try(subnet.name, subnet_key) } }
      } }
    )
    "azure_exadata_infrastructures" : merge(
      { for k, v in try(local.ext_dep_azure_oracle_database_map.azure_exadata_infrastructures, {}) : k => {
        "id"                   = v.id
        "name"                 = try(v.name, k)
        "oci_region"           = try(v.oci_region, null)
        "oci_compartment_ocid" = try(v.oci_compartment_ocid, null)
      } },
      { for k, v in module.azure_lz_oracle_exadata_infrastructure : k => {
        "id"                   = v.resource_id
        "name"                 = try(v.resource.name, k)
        "oci_region"           = try(v.oci_region, null)
        "oci_compartment_ocid" = try(v.oci_compartment_ocid, null)
      } }
    )
  } : null
  azure_oracle_database_dependency = local.azure_oracle_database_input_dependency != null || length(module.azure_lz_oracle_vm_cluster) > 0 || length(module.azure_lz_oracle_autonomous_database) > 0 ? merge(coalesce(local.azure_oracle_database_input_dependency, {}), {
    "azure_vm_clusters" = merge(
      { for k, v in try(local.ext_dep_azure_oracle_database_map.azure_vm_clusters, {}) : k => {
        "id"                   = try(v.id, null)
        "ocid"                 = try(v.ocid, v.vm_cluster_ocid, null)
        "hostname_actual"      = try(v.hostname_actual, null)
        "oci_region"           = try(v.oci_region, null)
        "oci_compartment_ocid" = try(v.oci_compartment_ocid, null)
        "oci_vcn_ocid"         = try(v.oci_vcn_ocid, null)
        "oci_nsg_ocid"         = try(v.oci_nsg_ocid, null)
      } },
      { for k, v in module.azure_lz_oracle_vm_cluster : k => {
        "id"                   = v.resource_id
        "ocid"                 = v.vm_cluster_ocid
        "hostname_actual"      = try(v.vm_cluster_hostname_actual, null)
        "oci_region"           = try(v.oci_region, null)
        "oci_compartment_ocid" = try(v.oci_compartment_ocid, null)
        "oci_vcn_ocid"         = try(v.oci_vcn_ocid, null)
        "oci_nsg_ocid"         = try(v.oci_nsg_ocid, null)
      } }
    )
    "azure_autonomous_databases" = merge(
      { for k, v in try(local.ext_dep_azure_oracle_database_map.azure_autonomous_databases, {}) : k => {
        "id"         = try(v.id, v.autonomous_db_id, null)
        "ocid"       = try(v.ocid, v.autonomous_db_ocid, null)
        "properties" = try(v.properties, v.autonomous_db_properties, null)
      } },
      { for k, v in module.azure_lz_oracle_autonomous_database : k => {
        "id"         = v.autonomous_db_id
        "ocid"       = v.autonomous_db_ocid
        "properties" = v.autonomous_db_properties
      } }
    )
  }) : null

  cloud_exadata_database_configuration = var.cloud_exadata_database_configuration == null ? null : merge(var.cloud_exadata_database_configuration, {
    cloud_db_homes_configuration = try(var.cloud_exadata_database_configuration.cloud_db_homes_configuration, null) == null ? null : {
      for db_home_key, db_home in var.cloud_exadata_database_configuration.cloud_db_homes_configuration :
      db_home_key => merge(db_home, {
        vm_cluster_id = try(
          can(regex("^ocid1\\.", try(db_home.vm_cluster_id, ""))) ? db_home.vm_cluster_id : local.azure_oracle_database_dependency.azure_vm_clusters[db_home.vm_cluster_id].ocid,
          try(db_home.vm_cluster_id, null)
        )
      })
    }
  })

  # var.nlbs_dependency
  ext_dep_nlbs_map = var.nlbs_dependency != null ? try(var.nlbs_dependency.nlbs_private_ips, jsondecode(file(var.nlbs_dependency)).nlbs_private_ips, null) : null
  nlbs_dependency  = { for k, v in coalesce(local.ext_dep_nlbs_map, {}) : k => { "id" : v.id } }
}
