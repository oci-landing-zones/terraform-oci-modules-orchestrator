# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_streams" {
  count                   = var.streams_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//streams?ref=v0.1.3"
  streams_configuration   = var.streams_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = var.networks_dependency
  kms_dependency          = var.kms_dependency
}

module "oci_lz_notifications" {
  count                       = var.notifications_configuration != null ? 1 : 0
  source                      = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//notifications?ref=v0.1.3"
  notifications_configuration = var.notifications_configuration
  compartments_dependency     = local.compartments_dependency
}

module "oci_lz_events" {
  count                   = var.events_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//events?ref=v0.1.3"
  events_configuration    = var.events_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
  functions_dependency    = var.functions_dependency
}

module "oci_lz_home_region_events" {
  count                   = var.home_region_events_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//events?ref=v0.1.3"
  providers               = { oci = oci.home }
  events_configuration    = var.home_region_events_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
  functions_dependency    = var.functions_dependency
}

module "oci_lz_alarms" {
  count                   = var.alarms_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//alarms?ref=v0.1.3"
  alarms_configuration    = var.alarms_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
}

module "oci_lz_logging" {
  count                   = var.logging_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//logging?ref=v0.1.3"
  logging_configuration   = var.logging_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_service_connectors" {
  count                   = var.service_connectors_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//service-connectors?ref=v0.1.3"
  providers = {
    oci = oci
    oci.home = oci.home
  }
  tenancy_ocid            = var.tenancy_ocid
  service_connectors_configuration = var.service_connectors_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
  logs_dependency         = merge({for k, v in coalesce(var.logging_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_logging) > 0 ? merge(coalesce(module.oci_lz_logging[0].service_logs,{}), coalesce(module.oci_lz_logging[0].custom_logs,{})): {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  kms_dependency          = var.kms_dependency
  functions_dependency    = var.functions_dependency
}