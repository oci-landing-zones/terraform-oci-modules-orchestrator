# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

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
  type    = any
  default = null
}

variable "groups_configuration" {
  type    = any
  default = null
}

variable "dynamic_groups_configuration" {
  type    = any
  default = null
}

variable "policies_configuration" {
  type    = any
  default = null
}

variable "identity_domains_configuration" {
  type    = any
  default = null
}

variable "identity_domain_groups_configuration" {
  type    = any
  default = null
}

variable "identity_domain_dynamic_groups_configuration" {
  type    = any
  default = null
}

variable "identity_domain_identity_providers_configuration" {
  type    = any
  default = null
}

variable "identity_domain_applications_configuration" {
  type    = any
  default = null
}
variable "network_configuration" {
  type    = any
  default = null
}

variable "nlb_configuration" {
  type    = any
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

variable "events_configuration" {
  type    = any
  default = null
}

variable "home_region_events_configuration" {
  type    = any
  default = null
}

variable "alarms_configuration" {
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

variable "scanning_configuration" {
  type    = any
  default = null
}

variable "cloud_guard_configuration" {
  type    = any
  default = null
}

variable "security_zones_configuration" {
  type    = any
  default = null
}

variable "vaults_configuration" {
  type    = any
  default = null
}

variable "zpr_configuration" {
  type    = any
  default = null
}

variable "bastions_configuration" {
  type    = any
  default = null
}

variable "budgets_configuration" {
  type    = any
  default = null
}

variable "tags_configuration" {
  type    = any
  default = null
}

variable "instances_configuration" {
  type    = any
  default = null
}

variable "object_storage_configuration" {
  type    = any
  default = null
}

variable "compartments_dependency" {
  type    = any
  default = null
}

variable "tags_dependency" {
  type    = any
  default = null
}

variable "network_dependency" {
  type    = any
  default = null
}

variable "kms_dependency" {
  type    = any
  default = null
}

variable "logging_dependency" {
  type    = any
  default = null
}

variable "streams_dependency" {
  type    = any
  default = null
}

variable "topics_dependency" {
  type    = any
  default = null
}

variable "functions_dependency" {
  type    = any
  default = null
}

variable "vaults_dependency" {
  type    = any
  default = null
}

variable "instances_dependency" {
  type    = any
  default = null
}

variable "nlbs_dependency" {
  type    = any
  default = null
}

variable "output_path" {
  type    = string
  default = null
}