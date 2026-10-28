# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  tag_namespaces = {
    for key in(try(var.tags_configuration.namespaces, null) == null ? [] : keys(var.tags_configuration.namespaces)) : key => var.tags_configuration.namespaces[key]
  }

  # Keep namespace/tag creation independent of compartments created by this stack.
  tags_configuration_without_defaults = var.tags_configuration == null ? null : merge(var.tags_configuration, {
    namespaces = {
      for namespace_key, namespace in local.tag_namespaces : namespace_key => merge(namespace, {
        tags = {
          for tag_key, tag in { for key in(try(namespace.tags, null) == null ? [] : keys(namespace.tags)) : key => namespace.tags[key] } : tag_key => merge(tag, {
            tag_defaults = null
          })
        }
      })
    }
  })

  tag_defaults = {
    for default in flatten([
      for namespace in local.tag_namespaces : [
        for tag_key, tag in { for key in(try(namespace.tags, null) == null ? [] : keys(namespace.tags)) : key => namespace.tags[key] } : [
          for default_key, default in { for key in(try(tag.tag_defaults, null) == null ? [] : keys(tag.tag_defaults)) : key => tag.tag_defaults[key] } : [
            for compartment_id in coalesce(default.compartment_ids, []) : {
              key              = "${default_key}.${compartment_id}"
              tag_key          = tag_key
              compartment_id   = compartment_id
              default_value    = default.default_value
              is_user_required = coalesce(try(default.is_user_required, null), false)
            }
          ]
        ]
      ]
    ]) : default.key => default
  }
}

resource "oci_identity_tag_default" "these" {
  for_each = local.tag_defaults

  compartment_id = startswith(each.value.compartment_id, "ocid1.") ? each.value.compartment_id : (
    upper(each.value.compartment_id) == "TENANCY-ROOT" ? var.tenancy_ocid : local.compartments_dependency[each.value.compartment_id].id
  )
  tag_definition_id = module.oci_lz_tags[0].tags[each.value.tag_key].id
  value             = each.value.default_value
  is_required       = each.value.is_user_required

  depends_on = [module.oci_lz_compartments, time_sleep.tag_propagation]
}

resource "time_sleep" "tag_defaults_propagation" {
  count = length(local.tag_defaults) > 0 ? 1 : 0

  create_duration = "10s"
  triggers = {
    # Repeat the propagation wait when defaults are added, replaced or updated.
    tag_defaults = sha256(jsonencode(oci_identity_tag_default.these))
  }

  depends_on = [oci_identity_tag_default.these]
}
