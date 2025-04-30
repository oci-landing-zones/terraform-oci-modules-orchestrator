# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_lz_streams" {
  count                   = var.streams_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//streams?ref=v0.2.3"
  streams_configuration   = var.streams_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = local.network_dependency
  kms_dependency          = var.kms_dependency
}

module "oci_lz_notifications" {
  count                       = var.notifications_configuration != null ? 1 : 0
  source                      = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//notifications?ref=v0.2.3"
  notifications_configuration = var.notifications_configuration
  compartments_dependency     = local.compartments_dependency
}

module "oci_lz_events" {
  count                   = var.events_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//events?ref=v0.2.3"
  tenancy_ocid            = var.tenancy_ocid
  events_configuration    = var.events_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = local.streams_dependency #merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = local.topics_dependency  #merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
  functions_dependency    = var.functions_dependency
}

module "oci_lz_home_region_events" {
  count                   = var.home_region_events_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//events?ref=v0.2.3"
  providers               = { oci = oci.home }
  tenancy_ocid            = var.tenancy_ocid
  events_configuration    = var.home_region_events_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = local.streams_dependency #merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = local.topics_dependency  #merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
  functions_dependency    = var.functions_dependency
}

module "oci_lz_alarms" {
  count                   = var.alarms_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//alarms?ref=v0.2.3"
  tenancy_ocid            = var.tenancy_ocid
  alarms_configuration    = var.alarms_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = local.streams_dependency #merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_streams) > 0 ? module.oci_lz_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = local.topics_dependency  #merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_lz_notifications) > 0 ? module.oci_lz_notifications[0].topics : {}) : k => {"id" : v.id}})
}

module "oci_lz_logging" {
  count                   = var.logging_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//logging?ref=v0.2.3"
  tenancy_ocid            = var.tenancy_ocid
  logging_configuration   = var.logging_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_lz_service_connectors" {
  count  = var.service_connectors_configuration != null ? 1 : 0
  source = "git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//service-connectors?ref=v0.2.3"
  providers = {
    oci                  = oci
    oci.home             = oci.home
    oci.secondary_region = oci.secondary_region
  }
  tenancy_ocid                     = var.tenancy_ocid
  service_connectors_configuration = var.service_connectors_configuration
  compartments_dependency          = local.compartments_dependency
  streams_dependency               = local.streams_dependency
  topics_dependency                = local.topics_dependency
  logs_dependency                  = local.logs_dependency
  kms_dependency                   = local.kms_dependency
  functions_dependency             = var.functions_dependency
}
