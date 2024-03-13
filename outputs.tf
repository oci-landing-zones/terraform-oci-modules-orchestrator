# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "provisioned_identity_resources" {
  description = "Provisioned identity resources"
  value = {
    compartments   = length(module.oci_lz_compartments) > 0 ? module.oci_lz_compartments[0].compartments : {},
    groups         = length(module.oci_lz_groups) > 0 ? module.oci_lz_groups[0].groups : {},
    memberships    = length(module.oci_lz_groups) > 0 ? module.oci_lz_groups[0].memberships : {},
    dynamic_groups = length(module.oci_lz_dynamic_groups) > 0 ? module.oci_lz_dynamic_groups[0].dynamic_groups : {},
    policies       = length(module.oci_lz_policies) > 0 ? module.oci_lz_policies[0].policies : {}
  }
}

output "provisioned_networking_resources" {
  description = "Provisioned networking resources"
  value       = length(module.oci_lz_networking) > 0 ? module.oci_lz_networking[0].provisioned_networking_resources : null
}

output "provisioned_observability_resources" {
  description = "Provisioned streaming resources"
  value = {
    # streams module
    streams = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}
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
    service_connectors = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connectors : {}
    service_connector_buckets = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_buckets : {}
    service_connector_streams = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_streams : {}
    service_connector_topics  = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_topics : {}
    service_connector_policies = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_policies : {}
  }  
}

# output "provisioned_streaming_resources" {
#   description = "Provisioned streaming resources"
#   value = {
#     streams = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}
#     stream_pools = length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].stream_pools : {}
#   }  
# }

# output "provisioned_events_resources" {
#   description = "Provisioned events resources"
#   value = {
#     events        = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].events : {}
#     topics        = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].topics : {}
#     subscriptions = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].subscriptions : {}
#     streams       = length(module.oci_lz_events) > 0 ? module.oci_lz_events[0].streams : {}
#   }  
# }

# output "provisioned_home_region_events_resources" {
#   description = "Provisioned events resources in the home region"
#   value = {
#     events = length(module.oci_lz_home_region_events) > 0 ? module.oci_lz_home_region_events[0].events : {}
#   }  
# }

# output "provisioned_alarms_resources" {
#   description = "Provisioned alarms resources"
#   value = {
#     alarms        = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].alarms : {}
#     topics        = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].topics : {}
#     subscriptions = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].subscriptions : {}
#     streams       = length(module.oci_lz_alarms) > 0 ? module.oci_lz_alarms[0].streams : {}
#   }  
# }

# output "provisioned_logging_resources" {
#   description = "Provisioned logging resources"
#   value = {
#     log_groups               = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].log_groups : {}
#     service_logs             = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].service_logs : {}
#     custom_logs              = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].custom_logs : {}
#     custom_logs_agent_config = length(module.oci_lz_logging) > 0 ? module.oci_lz_logging[0].custom_logs_agent_config : {}
#   }  
# }

# output "provisioned_notifications_resources" {
#   description = "Provisioned notifications resources"
#   value = {
#     topics        = length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}
#     subscriptions = length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].subscriptions : {}
#   }  
# }

# output "provisioned_service_connectors_resources" {
#   description = "Provisioned service connectors resources"
#   value = {
#     service_connectors = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connectors : {}
#     service_connector_buckets = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_buckets : {}
#     service_connector_streams = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_streams : {}
#     service_connector_topics  = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_topics : {}
#     service_connector_policies = length(module.oci_lz_service_connectors) > 0 ? module.oci_lz_service_connectors[0].service_connector_policies : {}
#   }  
# }