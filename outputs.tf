# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "iam_resources" {
  description = "Provisioned identity resources"
  value = {
    compartments     = length(module.oci_lz_compartments) > 0 ? module.oci_lz_compartments[0].compartments : {},
    groups           = length(module.oci_lz_groups) > 0 ? module.oci_lz_groups[0].groups : {},
    memberships      = length(module.oci_lz_groups) > 0 ? module.oci_lz_groups[0].memberships : {},
    dynamic_groups   = length(module.oci_lz_dynamic_groups) > 0 ? module.oci_lz_dynamic_groups[0].dynamic_groups : {},
    policies         = length(module.oci_lz_policies) > 0 ? module.oci_lz_policies[0].policies : {}
    identity_domains = length(module.oci_lz_identity_domains) > 0 ? module.oci_lz_identity_domains[0].identity_domains : {}
  }
}

output "network_resources" {
  description = "Provisioned networking resources"
  value       = length(module.oci_lz_network) > 0 ? module.oci_lz_network[0].provisioned_networking_resources : null
}

output "observability_resources" {
  description = "Provisioned streaming resources"
  value = {
    # streams module
    streams      = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}
    stream_pools = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].stream_pools : {}
    # events module
    events               = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].events : {}
    events_topics        = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].topics : {}
    events_subscriptions = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].subscriptions : {}
    events_streams       = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].streams : {}
    events_home_region   = length(module.oci_lz_home_region_events) > 0 ? module.oci_lz_home_region_events[0].events : {}
    # alarms module
    alarms               = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].alarms : {}
    alarms_topics        = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].topics : {}
    alarms_subscriptions = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].subscriptions : {}
    alarms_streams       = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].streams : {}
    # logging module
    log_groups               = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].log_groups : {}
    service_logs             = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].service_logs : {}
    custom_logs              = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].custom_logs : {}
    custom_logs_agent_config = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].custom_logs_agent_config : {}
    # notifications module
    notifications_topics        = length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}
    notifications_subscriptions = length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].subscriptions : {}
    # service connectors module
    service_connectors         = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connectors : {}
    service_connector_buckets  = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_buckets : {}
    service_connector_streams  = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_streams : {}
    service_connector_topics   = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_topics : {}
    service_connector_policies = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_policies : {}
  }
}

output "security_resources" {
  description = "Provisioned security resources"
  value = {
    keys     = length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].keys : {}
    vaults   = length(module.oci_lz_vaults) > 0 ? module.oci_lz_vaults[0].vaults : {}
    bastions = length(module.oci_lz_bastions) > 0 ? module.oci_lz_bastions[0].bastions : {}
  }
}

output "governance_resources" {
  description = "Provisioned governance resources"
  value = {
    budgets = length(module.oci_lz_budgets) > 0 ? module.oci_lz_budgets[0].budgets : {}
    tags    = length(module.oci_lz_tags) > 0 ? module.oci_lz_tags[0].tags : {}
  }
}

output "compute_resources" {
  description = "Provisioned compute resources"
  value = {
    instances       = length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].instances : {}
    secondary_vnics = length(module.oci_lz_compute) > 0 ? module.oci_lz_compute[0].secondary_vnics : {}
  }
}

output "nlb_resources" {
  description = "Provisioned NLB resources"
  value = {
    nlbs_private_ips = length(module.oci_lz_nlb) > 0 ? module.oci_lz_nlb[0].nlbs_primary_private_ips : {}
    nlbs_public_ips  = length(module.oci_lz_nlb) > 0 ? module.oci_lz_nlb[0].nlbs_public_ips : {}
  }
}

resource "local_file" "compartments_output" {
  count    = var.output_path != null && length(module.oci_lz_compartments) > 0 ? 1 : 0
  content  = jsonencode({ "compartments" : { for k, v in module.oci_lz_compartments[0].compartments : k => { "id" : v.id } } })
  filename = "${var.output_path}/compartments_output.json"
}

resource "local_file" "identity_domains_output" {
  count    = var.output_path != null && length(module.oci_lz_identity_domains) > 0 ? 1 : 0
  content  = jsonencode({ "identity_domains" : { for k, v in module.oci_lz_identity_domains[0].identity_domains : k => { "id" : v.id } } })
  filename = "${var.output_path}/identity_domains_output.json.json"
}

resource "local_file" "network_output" {
  count = var.output_path != null && length(module.oci_lz_network) > 0 ? 1 : 0
  content = jsonencode({ "network_resources" : {
    "vcns" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.vcns : k => { "id" : v.id } },
    "subnets" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.subnets : k => { "id" : v.id } },
    "network_security_groups" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.network_security_groups : k => { "id" : v.id } }
    "dynamic_routing_gateways" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.dynamic_routing_gateways : k => { "id" : v.id } }
    "drg_attachments" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.drg_attachments : k => { "id" : v.id } }
    "remote_peering_connections" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.remote_peering_connections : k => { "id" : v.id } }
    "local_peering_gateways" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.local_peering_gateways : k => { "id" : v.id } }
    "drg_route_tables" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.drg_route_tables : k => { "id" : v.id } }
    "dns_resolver" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.dns_resolver : k => { "id" : v.id } }
    "dns_zones" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.dns_zones : k => { "id" : v.id } }
    "dns_views" : { for k, v in module.oci_lz_network[0].provisioned_networking_resources.dns_views : k => { "id" : v.id } }
  } })
  filename = "${var.output_path}/network_output.json"
}

resource "local_file" "topics_output" {
  count    = var.output_path != null && length(module.oci_lz_notifications) > 0 ? 1 : 0
  content  = jsonencode({ "topics" : { for k, v in module.oci_lz_notifications[0].topics : k => { "id" : v.id } } })
  filename = "${var.output_path}/topics_output.json"
}

resource "local_file" "streams_output" {
  count    = var.output_path != null && length(module.oci_lz_streams) > 0 ? 1 : 0
  content  = jsonencode({ "streams" : { for k, v in module.oci_lz_streams[0].streams : k => { "id" : v.id } } })
  filename = "${var.output_path}/streams_output.json"
}

resource "local_file" "service_logs_output" {
  count    = var.output_path != null && length(module.oci_lz_logging) > 0 ? 1 : 0
  content  = jsonencode({ "service_logs" : { for k, v in module.oci_lz_logging[0].service_logs : k => { "id" : v.id, "compartment_id" : v.compartment_id } } })
  filename = "${var.output_path}/service_logs_output.json"
}

resource "local_file" "custom_logs_output" {
  count    = var.output_path != null && length(module.oci_lz_logging) > 0 ? 1 : 0
  content  = jsonencode({ "custom_logs" : { for k, v in module.oci_lz_logging[0].custom_logs : k => { "id" : v.id, "compartment_id" : v.compartment_id } } })
  filename = "${var.output_path}/custom_logs_output.json"
}

resource "local_file" "vaults_output" {
  count    = var.output_path != null && length(module.oci_lz_vaults) > 0 ? 1 : 0
  content  = jsonencode({ "vaults" : { for k, v in module.oci_lz_vaults[0].vaults : k => { "management_endpoint" : v.management_endpoint } } })
  filename = "${var.output_path}/vaults_output.json"
}

resource "local_file" "keys_output" {
  count    = var.output_path != null && length(module.oci_lz_vaults) > 0 ? 1 : 0
  content  = jsonencode({ "keys" : { for k, v in module.oci_lz_vaults[0].keys : k => { "id" : v.id } } })
  filename = "${var.output_path}/keys_output.json"
}

resource "local_file" "bastions_output" {
  count    = var.output_path != null && length(module.oci_lz_bastions) > 0 ? 1 : 0
  content  = jsonencode({ "bastions" : { for k, v in module.oci_lz_bastions[0].bastions : k => { "id" : v.id } } })
  filename = "${var.output_path}/bastions_output.json"
}

resource "local_file" "tags_output" {
  count    = var.output_path != null && length(module.oci_lz_tags) > 0 ? 1 : 0
  content  = jsonencode({ "tags" : { for k, v in module.oci_lz_tags[0].tags : k => { "id" : v.id } } })
  filename = "${var.output_path}/tags_output.json"
}

resource "local_file" "instances_output" {
  count = var.output_path != null && length(module.oci_lz_compute) > 0 ? 1 : 0
  content = jsonencode({ "instances" : { for k, v in module.oci_lz_compute[0].instances : k => { "id" : v.id, "private_ip" : v.create_vnic_details[0].private_ip } },
  "secondary_vnics" : { for k, v in module.oci_lz_compute[0].secondary_vnics : k => { "id" : v.id, "private_ip" : v.private_ip_address } } })
  filename = "${var.output_path}/instances_output.json"
}

resource "local_file" "nlbs_output" {
  count = var.output_path != null && length(module.oci_lz_nlb) > 0 ? 1 : 0
  content = jsonencode({ "nlbs_private_ips" : { for k, v in module.oci_lz_nlb[0].nlbs_primary_private_ips : k => { "id" : v.private_ips[0].id } },
  "nlbs_public_ips" : { for k, v in module.oci_lz_nlb[0].nlbs_public_ips : k => { "private_ip_id" : v.private_ip_id, "id" : v.id } } })
  filename = "${var.output_path}/nlbs_output.json"
}