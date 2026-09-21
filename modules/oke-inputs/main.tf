variable "configurations" {
  type    = any
  default = null
}

locals {
  aliases = {
    clusters = ["oke_clusters_configuration", "clusters_configuration"]
    workers  = ["oke_workers_configuration", "workers_configuration"]
  }
}

output "configurations" {
  value = { for kind, names in local.aliases : kind => try(var.configurations[names[0]], var.configurations[names[1]], null) }
  precondition {
    condition = alltrue([for names in values(local.aliases) :
      length(setintersection(toset(keys(coalesce(var.configurations, {}))), toset(names))) < 2
    ])
    error_message = "Supply only one OKE JSON envelope per family: oke_clusters_configuration or clusters_configuration, and oke_workers_configuration or workers_configuration."
  }
}
