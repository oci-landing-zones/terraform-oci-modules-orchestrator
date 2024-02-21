# ####################################################################################################### #
# Copyright (c) 2023 Oracle and/or its affiliates,  All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https: //oss.oracle.com/licenses/upl. #
# Author: Cosmin Tudor                                                                                    #
# Author email: cosmin.tudor@oracle.com                                                                   #
# Last Modified: Tue Feb 21, 2024                                                                         #
# Modified by: andre.correa@oracle.com                                                                    #
# ####################################################################################################### #


output "provisioned_identity_resources" {
  description = "Provisioned identity resources"
  value = {
    compartments   = length(module.oci_orchestrator_compartments) > 0 ? module.oci_orchestrator_compartments[0].compartments : {},
    groups         = length(module.oci_orchestrator_groups) > 0 ? module.oci_orchestrator_groups[0].groups : {},
    memberships    = length(module.oci_orchestrator_groups) > 0 ? module.oci_orchestrator_groups[0].memberships : {},
    dynamic_groups = length(module.oci_orchestrator_dynamic_groups) > 0 ? module.oci_orchestrator_dynamic_groups[0].dynamic_groups : {},
    policies       = length(module.oci_orchestrator_policies) > 0 ? module.oci_orchestrator_policies[0].policies : {}
  }
}

output "provisioned_networking_resources" {
  description = "Provisioned networking resources"
  value       = length(module.oci_orchestrator_networking) > 0 ? module.oci_orchestrator_networking[0].provisioned_networking_resources : null
}

output "provisioned_streaming_resources" {
  value = {
    streams = length(module.oci_orchestrator_streams) > 0 ? module.oci_orchestrator_streams[0].streams : {}
    stream_pools = length(module.oci_orchestrator_streams) > 0 ? module.oci_orchestrator_streams[0].stream_pools : {}
  }  
}