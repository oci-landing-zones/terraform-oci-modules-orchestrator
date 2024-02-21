# ####################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates,  All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https: //oss.oracle.com/licenses/upl. #
# Author: Andre Correa                                                                                    #
# Author email: andre.correa@oracle.com                                                                   #
# Last Modified: Wed Feb 21, 2024                                                                         #
# Modified by: andre.correa@oracle.com                                                                    #
# ####################################################################################################### #

module "oci_orchestrator_streams" {
  count                   = var.streams_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//streams?ref=v0.1.3"
  streams_configuration   = var.streams_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = var.networks_dependency
  kms_dependency          = var.kms_dependency
}

module "oci_orchestrator_notifications" {
  count                       = var.notifications_configuration != null ? 1 : 0
  source                      = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//notifications?ref=v0.1.3"
  notifications_configuration = var.notifications_configuration
  compartments_dependency     = local.compartments_dependency
}

module "oci_orchestrator_logging" {
  count                   = var.logging_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//logging?ref=v0.1.3"
  logging_configuration   = var.logging_configuration
  compartments_dependency = local.compartments_dependency
}

module "oci_orchestrator_service_connectors" {
  count                   = var.service_connectors_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//service-connectors?ref=v0.1.3"
  providers = {
    oci = oci
    oci.home = oci.home
  }
  tenancy_ocid            = var.tenancy_ocid
  service_connectors_configuration = var.service_connectors_configuration
  compartments_dependency = local.compartments_dependency
  streams_dependency      = merge({for k, v in coalesce(var.streams_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_orchestrator_streams) > 0 ? module.oci_orchestrator_streams[0].streams : {}) : k => {"id" : v.id, "compartment_id" : v.compartment_id}})
  topics_dependency       = merge({for k, v in coalesce(var.topics_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_orchestrator_notifications) > 0 ? module.oci_orchestrator_notifications[0].topics : {}) : k => {"id" : v.id}})
  logs_dependency         = merge({for k, v in coalesce(var.logging_dependency,{}) : k => {"id" : v.id}}, {for k, v in (length(module.oci_orchestrator_logging) > 0 ? merge(coalesce(module.oci_orchestrator_logging[0].service_logs,{}), coalesce(module.oci_orchestrator_logging[0].custom_logs,{})): {}) : k => {"id" : v.id}})
  kms_dependency          = var.kms_dependency
  functions_dependency    = var.functions_dependency
}