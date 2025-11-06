# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

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
  type    = string
  default = null
}
variable "github_base_url" {
  type        = string
  default     = null
  description = "GitHub base API endpoint. Required when working with GitHub Enterprise. The value must end with a slash. E.g. https://example.com/"
}

variable "github_file_prefix" {
  type    = string
  default = null
}

variable "input_config_files_urls" {
  type        = list(string)
  default     = null
  description = "List of URLs that point to the JSON configuration files."
}

# variable "dependency_files_urls" {
#   type        = list(string)
#   default     = null
#   description = "List of URLs that point to files containing dependencies expressed in the input config files."
# }

variable "save_output" {
  type        = bool
  default     = false
  description = "Whether to save the module output. This is typically done when the output is used as the input to another module."
}

variable "oci_object_prefix" {
  type        = string
  default     = null
  description = "The OCI object prefix. Use this to organize the output and avoid overwriting when you run multiple instances of this stack. The object name is appended to the provided prefix, like oci_object_prefix/object_name."
}

variable "configuration_source" {
  type        = string
  default     = "url"
  description = "The source where configuration files are pulled from."
}
variable "oci_configuration_bucket" {
  type        = string
  default     = null
  description = "The OCI Object Storage bucket where Landing Zone configuration files are kept."
}
variable "oci_configuration_objects" {
  type        = list(string)
  default     = null
  description = "The OCI Object Storage objects containing the Landing Zone configurations."
}
variable "oci_dependency_objects" {
  type        = list(string)
  default     = null
  description = "The OCI Object Storage objects containing stack dependencies."
}

variable "github_configuration_repo" {
  type    = string
  default = null

  validation {
    condition     = var.github_configuration_repo != null ? strcontains(var.github_configuration_repo, "/") : true
    error_message = "Github repository is expected in format organization/repository or user/repository"
  }
}
variable "github_configuration_branch" {
  type    = string
  default = null
}
variable "github_configuration_files" {
  type    = list(string)
  default = null
}
variable "github_dependency_files" {
  type        = list(string)
  default     = null
  description = "The GitHub files containing stack dependencies."
}
variable "url_dependency_source" {
  type    = string
  default = ""
}

variable "url_dependency_source_oci_bucket" {
  type    = string
  default = null
}

variable "url_dependency_source_oci_objects" {
  type    = list(string)
  default = null
}

variable "url_dependency_source_github_token" {
  type    = string
  default = null
}

variable "url_dependency_source_github_repo" {
  type    = string
  default = null
}

variable "url_dependency_source_github_branch" {
  type    = string
  default = null
}

variable "url_dependency_source_github_dependency_files" {
  type    = list(string)
  default = null
}

