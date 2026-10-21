# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  logging_configuration = var.logging_configuration == null ? null : merge(var.logging_configuration, {
    service_logs = {
      for key, log in coalesce(lookup(var.logging_configuration, "service_logs", null), {}) : key => merge(log, {
        resource_id = log.service == "flowlogs" && contains(["vcn", "subnet"], log.category) ? coalesce(
          startswith(log.resource_id, "ocid1.") ? log.resource_id : null,
          try(local.network_foundation_dependency[{ vcn = "vcns", subnet = "subnets" }[log.category]][log.resource_id].id, null)
        ) : log.resource_id
      })
    }
  })
}
