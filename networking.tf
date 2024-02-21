# ####################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates,  All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https: //oss.oracle.com/licenses/upl. #
# Author: Cosmin Tudor                                                                                    #
# Author email: cosmin.tudor@oracle.com                                                                   #
# Last Modified: Tue Feb 21, 2024                                                                         #
# Modified by: andre.correa@oracle.com                                                                    #
# ####################################################################################################### #

module "oci_orchestrator_networking" {
  count                   = var.network_configuration != null ? 1 : 0
  source                  = "git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking.git?ref=v0.6.4"
  network_configuration   = var.network_configuration
  compartments_dependency = local.compartments_dependency
  network_dependency      = var.networks_dependency
}