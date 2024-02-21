# ####################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates,  All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https: //oss.oracle.com/licenses/upl. #
# Author: Cosmin Tudor                                                                                    #
# Author email: cosmin.tudor@oracle.com                                                                   #
# Last Modified: Tue Feb 20, 2024                                                                         #
# Modified by: andre.correa@oracle.com                                                                    #
# ####################################################################################################### #

# User Credentials 
variable "tenancy_ocid" {
  type    = string
  default = null
}
variable "user_ocid" {
  type    = string
  default = null
}
variable "fingerprint" {
  type    = string
  default = null
}
variable "private_key_path" {
  type    = string
  default = null
}
variable "private_key_password" {
  type    = string
  default = null
}
variable "region" {
  type    = string
  default = null
}

variable "compartments_configuration" {
  type = any
  default = null
}

variable "groups_configuration" {
  type = any
  default = null
}

variable "dynamic_groups_configuration" {
  type = any
  default = null
}

variable "policies_configuration" {
  type = any
  default = null
}

variable "network_configuration" {
  type = any
  default = null
}

variable "streams_configuration" {
  type    = any
  default = null
}

variable "notifications_configuration" {
  type    = any
  default = null
}

variable "service_connectors_configuration" {
  type    = any
  default = null
}

variable "logging_configuration" {
  type    = any
  default = null
}

variable "compartments_dependency" {
  type    = map(any)
  default = null
}

variable "tags_dependency" {
  type    = map(any)
  default = null
}

variable "networks_dependency" {
  type    = map(any)
  default = null
}

variable "kms_dependency" {
  type    = map(any)
  default = null
}

variable "logging_dependency" {
  type    = map(any)
  default = null
}

variable "streams_dependency" {
  type    = map(any)
  default = null
}

variable "topics_dependency" {
  type    = map(any)
  default = null
}

variable "functions_dependency" {
  type    = map(any)
  default = null
}