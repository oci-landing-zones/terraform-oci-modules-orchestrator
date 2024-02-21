# ####################################################################################################### #
# Copyright (c) 2024 Oracle and/or its affiliates,  All rights reserved.                                  #
# Licensed under the Universal Permissive License v 1.0 as shown at https: //oss.oracle.com/licenses/upl. #
# Author: Cosmin Tudor                                                                                    #
# Author email: cosmin.tudor@oracle.com                                                                   #
# Last Modified: Thu Feb 21, 2023                                                                         #
# Modified by: andre.correa@oracle.com                                                                    #
# ####################################################################################################### #

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
variable "github_token" {
  type = string
  default = null
}
variable "github_repository_name" {
  type = string
  default = null
}
variable "github_branch_name" {
  type = string
  default = null
}
variable "github_file_prefix" {
  type = string
  default = null
}

variable "input_config_files_urls" {
  type        = list(string)
  default     = null
  description = "List of URLs that point to the JSON configuration files."
}

variable "dependency_files_urls" {
  type        = list(string)
  default     = null
  description = "List of URLs that point to files containing dependencies expressed in the input config files."
}

variable "save_output" {
  type = bool
  default = true
  description = "Whether to save the module output. This is typically done when the output is used as the input to another module."
}

variable "output_location" {
  type = string
  default = "ocibucket"
  description = "The location type where the output is saved. Valid values are ocibucket or github."
}

variable "oci_bucket_name" {
  type = string
  default = null
  description = "The OCI bucket name. The executing user MUST have write permissions on the bucket."
}

variable "oci_object_prefix" {
  type = string
  default = null
  description = "The OCI object prefix. Use this to organize the output and avoid overwriting when you run multiple instances of this stack. The object name is appended to the provided prefix, like oci_object_prefix/object_name."
}
