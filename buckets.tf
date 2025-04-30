# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_objectstorage_namespace" "this" {
  count          = var.object_storage_configuration != null ? 1 : 0
  compartment_id = var.tenancy_ocid
}

### Creating config bucket
resource "oci_objectstorage_bucket" "these" {
  for_each       = var.object_storage_configuration != null ? (var.object_storage_configuration.buckets != null ? var.object_storage_configuration.buckets : {}) : {}
  compartment_id = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : local.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.object_storage_configuration.default_compartment_id)) > 0 ? var.object_storage_configuration.default_compartment_id : local.compartments_dependency[var.object_storage_configuration.default_compartment_id].id)
  name           = each.value.name
  namespace      = data.oci_objectstorage_namespace.this[0].namespace
}
