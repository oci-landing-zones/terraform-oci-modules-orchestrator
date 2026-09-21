# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0.

terraform {
  required_version = ">= 1.5.0"
}

variable "clusters_configuration" {
  type    = any
  default = null
  validation {
    condition     = var.clusters_configuration == null ? true : can(keys(var.clusters_configuration.clusters))
    error_message = "OKE compatibility: clusters_configuration must contain a clusters map."
  }
}
variable "workers_configuration" {
  type    = any
  default = null
}

locals {
  clusters = { for k in try(keys(var.clusters_configuration.clusters), []) : k => var.clusters_configuration.clusters[k] }
  managed  = { for k in try(keys(var.workers_configuration.node_pools), []) : k => var.workers_configuration.node_pools[k] }
  virtual  = { for k in try(keys(var.workers_configuration.virtual_node_pools), []) : k => var.workers_configuration.virtual_node_pools[k] }
  # Keep the two maps separate until collision checks have run.
  pools = concat(
    [for k, p in local.managed : { key = k, pool = p, virtual = false }],
    [for k, p in local.virtual : { key = k, pool = p, virtual = true }]
  )
  cluster_tags = { for k, c in local.clusters : k => {
    defined  = try(coalesce(try(c.defined_tags, null), try(var.clusters_configuration.default_defined_tags, null)), null)
    freeform = try(coalesce(try(c.freeform_tags, null), try(var.clusters_configuration.default_freeform_tags, null)), null)
  } }
  signing_keys = { for k, c in local.clusters : k => try(coalesce(try(c.image_signing.img_kms_key_id, null), try(var.clusters_configuration.default_img_kms_key_id, null)), null) }
  clusters_normalized = { for k, c in local.clusters : k => {
    name           = c.name
    compartment_id = try(coalesce(try(c.compartment_id, null), try(var.clusters_configuration.default_compartment_id, null)), null)
    # Legacy per-object defaults take precedence over the ineffective global CIS default.
    cis_level          = tostring(coalesce(try(c.cis_level, null), "1"))
    cluster_type       = coalesce(try(c.is_enhanced, null), false) ? "enhanced" : "basic"
    cni_type           = coalesce(try(c.cni_type, null), "flannel")
    kubernetes_version = try(c.kubernetes_version, null)
    defined_tags       = local.cluster_tags[k].defined
    freeform_tags      = local.cluster_tags[k].freeform
    networking = {
      vcn_id                 = c.networking.vcn_id
      api_endpoint_subnet_id = c.networking.api_endpoint_subnet_id
      api_endpoint_nsg_ids   = try(c.networking.api_endpoint_nsg_ids, null)
      service_lb_subnet_ids  = try(c.networking.services_subnet_id, null)
    }
    encryption = {
      kube_secret_kms_key_id = try(coalesce(try(c.encryption.kube_secret_kms_key_id, null), try(var.clusters_configuration.default_kube_secret_kms_key_id, null)), null)
    }
    image_signing = {
      image_policy_enabled = coalesce(try(c.image_signing.image_policy_enabled, null), false)
      kms_key_ids          = local.signing_keys[k] == null ? [] : [local.signing_keys[k]]
    }
    options = {
      kubernetes_network_config = try(c.options.kubernetes_network_config, null)
      openid_connect            = try(c.options.openid_connect, null)
      persistent_volume_config = {
        defined_tags  = try(coalesce(try(c.options.persistent_volume_config.defined_tags, null), try(var.clusters_configuration.default_defined_tags, null)), null)
        freeform_tags = try(coalesce(try(c.options.persistent_volume_config.freeform_tags, null), try(var.clusters_configuration.default_freeform_tags, null)), null)
      }
      service_lb_config = {
        defined_tags  = try(coalesce(try(c.options.service_lb_config.defined_tags, null), try(var.clusters_configuration.default_defined_tags, null)), null)
        freeform_tags = try(coalesce(try(c.options.service_lb_config.freeform_tags, null), try(var.clusters_configuration.default_freeform_tags, null)), null)
      }
    }
  } }
  worker_details = { for k, p in local.managed : k => {
    image     = try(p.node_config_details.image, null)
    ssh_path  = try(coalesce(try(p.node_config_details.ssh_public_key_path, null), try(var.workers_configuration.default_ssh_public_key_path, null)), null)
    script    = try(p.node_config_details.cloud_init.heredoc_script, null)
    placement = coalesce(try(p.node_config_details.placement, null), [])
  } }
  managed_normalized = { for k, p in local.managed : k => {
    name                         = p.name
    mode                         = "node-pool"
    size                         = try(p.size, null)
    kubernetes_version           = try(p.kubernetes_version, null)
    shape                        = p.node_config_details.node_shape
    ocpus                        = coalesce(try(p.node_config_details.flex_shape_settings.ocpus, null), 1)
    memory                       = coalesce(try(p.node_config_details.flex_shape_settings.memory, null), 16)
    boot_volume_size             = coalesce(try(p.node_config_details.boot_volume_size, null), 60)
    image_id                     = startswith(coalesce(local.worker_details[k].image, "none"), "ocid1.image.") ? local.worker_details[k].image : null
    os                           = "Oracle Linux"
    os_version                   = startswith(coalesce(local.worker_details[k].image, "none"), "ocid1.image.") ? null : (local.worker_details[k].image == "9\\.[0-9]+" ? "9" : local.worker_details[k].image)
    subnet_id                    = p.networking.workers_subnet_id
    nsg_ids                      = try(p.networking.workers_nsg_ids, null)
    pod_subnet_id                = try(p.networking.pods_subnet_id, null)
    pod_nsg_ids                  = try(p.networking.pods_nsg_ids, null)
    max_pods_per_node            = coalesce(try(p.networking.max_pods_per_node, null), 31)
    defined_tags                 = try(coalesce(try(p.defined_tags, null), try(var.workers_configuration.default_defined_tags, null)), null)
    freeform_tags                = try(coalesce(try(p.freeform_tags, null), try(var.workers_configuration.default_freeform_tags, null)), null)
    node_defined_tags            = try(coalesce(try(p.node_config_details.defined_tags, null), try(var.workers_configuration.default_defined_tags, null)), null)
    node_freeform_tags           = try(coalesce(try(p.node_config_details.freeform_tags, null), try(var.workers_configuration.default_freeform_tags, null)), null)
    node_labels                  = try(coalesce(try(p.initial_node_labels, null), try(var.workers_configuration.default_initial_node_labels, null)), null)
    node_metadata                = try(p.node_config_details.node_metadata, null)
    ssh_public_key               = local.worker_details[k].ssh_path == null ? null : (startswith(local.worker_details[k].ssh_path, "ssh-") ? local.worker_details[k].ssh_path : file(pathexpand(local.worker_details[k].ssh_path)))
    volume_kms_key_id            = try(coalesce(try(p.node_config_details.encryption.kms_key_id, null), try(var.workers_configuration.default_kms_key_id, null)), null)
    pv_transit_encryption        = coalesce(try(p.node_config_details.encryption.enable_encrypt_in_transit, null), false)
    capacity_reservation_id      = try(p.node_config_details.capacity_reservation_id, null)
    eviction_grace_duration      = coalesce(try(p.node_config_details.node_eviction.grace_duration, null), 3600)
    force_node_delete            = coalesce(try(p.node_config_details.node_eviction.force_delete, null), false)
    node_cycling_enabled         = coalesce(try(p.node_config_details.node_cycling.enable_cycling, null), try(p.enable_cycling, null), false)
    node_cycling_max_surge       = coalesce(try(p.node_config_details.node_cycling.max_surge, null), "1")
    node_cycling_max_unavailable = coalesce(try(p.node_config_details.node_cycling.max_unavailable, null), "0")
    placement_ads                = length(local.worker_details[k].placement) == 0 ? [1] : [for x in local.worker_details[k].placement : coalesce(try(x.availability_domain, null), 1)]
    placement_fds                = try(local.worker_details[k].placement[0].fault_domain, null) == null ? null : [format("FAULT-DOMAIN-%s", local.worker_details[k].placement[0].fault_domain)]
    preemptible_config = {
      enable                  = coalesce(try(local.worker_details[k].placement[0].enable_preemptible_node, null), false)
      is_preserve_boot_volume = coalesce(try(local.worker_details[k].placement[0].preserve_boot_volume_on_preempting, null), false)
    }
    # Preserve OKE-WE's explicit bootstrap rather than adding upstream boot scripts.
    disable_default_cloud_init = true
    cloud_init                 = local.worker_details[k].script == null ? [] : [{ content = local.worker_details[k].script, content_type = "text/x-shellscript" }]
  } }
  virtual_normalized = { for k, p in local.virtual : k => {
    name               = p.name
    mode               = "virtual-node-pool"
    size               = try(p.size, null)
    shape              = p.pod_shape
    subnet_id          = p.networking.workers_subnet_id
    nsg_ids            = try(p.networking.workers_nsg_ids, null)
    pod_subnet_id      = p.networking.pods_subnet_id
    pod_nsg_ids        = try(p.networking.pods_nsg_ids, null)
    defined_tags       = try(coalesce(try(p.defined_tags, null), try(var.workers_configuration.default_defined_tags, null)), null)
    freeform_tags      = try(coalesce(try(p.freeform_tags, null), try(var.workers_configuration.default_freeform_tags, null)), null)
    node_defined_tags  = try(coalesce(try(p.virtual_nodes_defined_tags, null), try(var.workers_configuration.default_defined_tags, null)), null)
    node_freeform_tags = try(coalesce(try(p.virtual_nodes_freeform_tags, null), try(var.workers_configuration.default_freeform_tags, null)), null)
    node_labels        = try(coalesce(try(p.initial_node_labels, null), try(var.workers_configuration.default_initial_node_labels, null)), null)
    taints             = try(p.taints, null)
  } }
}

output "clusters" {
  value = local.clusters_normalized
  precondition {
    condition = alltrue([for c in values(local.clusters) :
      !coalesce(try(c.networking.is_api_endpoint_public, null), false) &&
      !coalesce(try(c.networking.assign_public_ip_to_control_plane, null), false) &&
      !coalesce(try(c.options.add_ons.dashboard_enabled, null), false) &&
      !coalesce(try(c.options.add_ons.tiller_enabled, null), false) &&
      !coalesce(try(c.options.admission_controller.pod_policy_enabled, null), false)
    ])
    error_message = "OKE compatibility: public endpoints, Dashboard, Tiller and pod security policy admission are unsupported. Disable these explicitly before migration."
  }
}

output "workers" {
  value = { for c in keys(local.clusters) : c => {
    worker_pools = merge(
      { for k, p in local.managed_normalized : k => p if local.managed[k].cluster_id == c },
      { for k, p in local.virtual_normalized : k => p if local.virtual[k].cluster_id == c }
    )
  } }
  precondition {
    condition     = alltrue([for p in local.pools : contains(keys(local.clusters), p.pool.cluster_id)])
    error_message = "OKE compatibility: every worker cluster_id must reference a cluster key in oke_clusters_configuration; external clusters are unsupported."
  }
  precondition {
    condition     = length(setintersection(toset(keys(local.managed)), toset(keys(local.virtual)))) == 0
    error_message = "OKE compatibility: managed and virtual pool keys must be distinct."
  }
  precondition {
    condition = alltrue([for p in local.pools : try(
      coalesce(try(p.pool.compartment_id, null), try(var.workers_configuration.default_compartment_id, null), local.clusters_normalized[p.pool.cluster_id].compartment_id) == local.clusters_normalized[p.pool.cluster_id].compartment_id,
      false
    )])
    error_message = "OKE compatibility: each pool must explicitly resolve to its cluster compartment; cross-compartment pools are unsupported."
  }
  precondition {
    condition     = alltrue([for p in local.pools : p.virtual ? true : try(tostring(coalesce(try(p.pool.cis_level, null), "1")) == local.clusters_normalized[p.pool.cluster_id].cis_level, false)])
    error_message = "OKE compatibility: cluster and managed-pool CIS levels must match; review encryption requirements before migration."
  }
  precondition {
    condition = alltrue([for d in values(local.worker_details) : d.image == null ? false : (
      startswith(d.image, "ocid1.image.") || d.image == "9\\.[0-9]+" || can(regex("^[0-9]+(\\.[0-9]+)?$", d.image))
    )])
    error_message = "OKE compatibility: specify an image OCID, Oracle Linux major/minor version, or the OKE-WE OL9 selector; arbitrary image regexes and implicit image upgrades are unsupported."
  }
  precondition {
    condition = alltrue([for d in values(local.worker_details) : length(distinct([for x in d.placement : jsonencode({
      fd          = try(x.fault_domain, null)
      preemptible = coalesce(try(x.enable_preemptible_node, null), false)
      preserve    = coalesce(try(x.preserve_boot_volume_on_preempting, null), false)
      action      = coalesce(try(x.preemptible_node_action_type, null), "TERMINATE")
    })])) <= 1 && alltrue([for x in d.placement : coalesce(try(x.preemptible_node_action_type, null), "TERMINATE") == "TERMINATE"])])
    error_message = "OKE compatibility: heterogeneous per-AD placement/preemptible settings cannot be translated."
  }
  precondition {
    condition     = alltrue([for p in values(local.virtual) : length(coalesce(try(p.placement, null), [])) == 0])
    error_message = "OKE compatibility: legacy virtual pool placement requires manual review; the new module supports only automatic virtual fault-domain placement."
  }
  precondition {
    condition = alltrue([for p in values(local.managed) : try(p.node_config_details.cloud_init, null) == null ? true : (
      can(p.node_config_details.cloud_init.heredoc_script) &&
      length(setsubtract(toset(keys(p.node_config_details.cloud_init)), toset(["heredoc_script"]))) == 0
    )])
    error_message = "OKE compatibility: cloud_init accepts only the OKE-WE heredoc_script form; other bootstrap formats require manual conversion."
  }
}
