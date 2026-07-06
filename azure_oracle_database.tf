# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "azure_lz_oracle_vmc_network" {
  for_each = coalesce(try(var.azure_oracle_database_configuration.vmc_networks_configuration, null), {})

  source = "git::https://github.com/oci-landing-zones/terraform-oci-multicloud-azure.git//modules/azure-vnet-subnet?ref=v0.1.3"

  address_space                   = try(each.value.address_space, null)
  virtual_network_address_space   = try(each.value.virtual_network_address_space, null)
  location                        = each.value.location
  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  subnets                         = try(each.value.subnets, null)
  delegated_subnet_name           = try(each.value.delegated_subnet_name, "delegated")
  delegated_subnet_address_prefix = try(each.value.delegated_subnet_address_prefix, null)
  tags                            = try(each.value.tags, null)
}

module "azure_lz_oracle_exadata_infrastructure" {
  for_each = coalesce(try(var.azure_oracle_database_configuration.exadata_infrastructures_configuration, null), {})

  source = "git::https://github.com/oci-landing-zones/terraform-oci-multicloud-azure.git//modules/azurerm-ora-exadata-infra?ref=v0.1.3"

  location            = each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  zone                = each.value.zone
  compute_count       = try(each.value.compute_count, 2)
  storage_count       = try(each.value.storage_count, 3)
  shape               = try(each.value.shape, "Exadata.X9M")
  customer_contacts   = try(each.value.customer_contacts, [])
  maintenance_window = try(each.value.maintenance_window, {
    patching_mode = "Rolling"
    preference    = "NoPreference"
  })
  tags = try(each.value.tags, null)
}

module "azure_lz_oracle_vm_cluster" {
  depends_on = [
    module.azure_lz_oracle_vmc_network,
    module.azure_lz_oracle_exadata_infrastructure
  ]
  for_each = coalesce(try(var.azure_oracle_database_configuration.vm_clusters_configuration, null), {})

  source = "git::https://github.com/oci-landing-zones/terraform-oci-multicloud-azure.git//modules/azurerm-ora-exadata-vmc?ref=v0.1.3"

  resource_group_name               = each.value.resource_group_name
  location                          = each.value.location
  cloud_exadata_infrastructure_id   = try(each.value.cloud_exadata_infrastructure_id, local.azure_oracle_database_input_dependency.azure_exadata_infrastructures[each.value.exadata_infrastructure_key].id)
  cloud_exadata_infrastructure_name = try(each.value.cloud_exadata_infrastructure_name, local.azure_oracle_database_input_dependency.azure_exadata_infrastructures[each.value.exadata_infrastructure_key].name)
  cluster_name                      = try(each.value.cluster_name, null)
  hostname                          = try(each.value.hostname, null)
  time_zone                         = try(each.value.time_zone, null)
  license_model                     = try(each.value.license_model, "LicenseIncluded")
  gi_version                        = each.value.gi_version
  system_version                    = try(each.value.system_version, null)
  ssh_public_keys                   = each.value.ssh_public_keys
  tags                              = try(each.value.tags, null)
  vnet_id                           = try(each.value.vnet_id, local.azure_oracle_database_input_dependency.azure_vmc_networks[each.value.vmc_network_key].id)
  subnet_id                         = try(each.value.subnet_id, local.azure_oracle_database_input_dependency.azure_vmc_networks[each.value.vmc_network_key].subnets[try(each.value.delegated_subnet_key, "delegated")].id)
  backup_subnet_cidr                = try(each.value.backup_subnet_cidr, null)
  cpu_core_count                    = each.value.cpu_core_count
  memory_size_in_gbs                = try(each.value.memory_size_in_gbs, null)
  dbnode_storage_size_in_gbs        = try(each.value.dbnode_storage_size_in_gbs, null)
  data_storage_size_in_tbs          = try(each.value.data_storage_size_in_tbs, null)
  data_storage_percentage           = try(each.value.data_storage_percentage, null)
  is_local_backup_enabled           = try(each.value.is_local_backup_enabled, null)
  is_sparse_diskgroup_enabled       = try(each.value.is_sparse_diskgroup_enabled, null)
  is_diagnostic_events_enabled      = try(each.value.is_diagnostic_events_enabled, false)
  is_health_monitoring_enabled      = try(each.value.is_health_monitoring_enabled, false)
  is_incident_logs_enabled          = try(each.value.is_incident_logs_enabled, false)
  domain                            = try(each.value.domain, "")
  zone_id                           = try(each.value.zone_id, "")
}

module "azure_lz_oracle_autonomous_database" {
  depends_on = [module.azure_lz_oracle_vmc_network]
  for_each   = coalesce(try(var.azure_oracle_database_configuration.autonomous_databases_configuration, null), {})

  source = "git::https://github.com/oci-landing-zones/terraform-oci-multicloud-azure.git//modules/azure-oracle-adbs?ref=v0.1.3"

  location                                    = each.value.location
  nw_resource_group                           = try(each.value.nw_resource_group, local.azure_oracle_database_input_dependency.azure_vmc_networks[each.value.vmc_network_key].resource_group_name)
  nw_vnet_name                                = try(each.value.nw_vnet_name, local.azure_oracle_database_input_dependency.azure_vmc_networks[each.value.vmc_network_key].name)
  nw_delegated_subnet_name                    = try(each.value.nw_delegated_subnet_name, local.azure_oracle_database_input_dependency.azure_vmc_networks[each.value.vmc_network_key].subnets[try(each.value.delegated_subnet_key, "delegated")].name)
  db_resource_group                           = each.value.db_resource_group
  name                                        = each.value.name
  display_name                                = try(each.value.display_name, "")
  db_workload                                 = try(each.value.db_workload, "DW")
  mtls_connection_required                    = try(each.value.mtls_connection_required, false)
  backup_retention_period_in_days             = try(each.value.backup_retention_period_in_days, 60)
  compute_model                               = try(each.value.compute_model, "ECPU")
  data_storage_size_in_tbs                    = try(each.value.data_storage_size_in_tbs, 1)
  auto_scaling_for_storage_enabled            = try(each.value.auto_scaling_for_storage_enabled, false)
  admin_password                              = each.value.admin_password
  auto_scaling_enabled                        = try(each.value.auto_scaling_enabled, true)
  character_set                               = try(each.value.character_set, "AL32UTF8")
  compute_count                               = try(each.value.compute_count, 2)
  national_character_set                      = try(each.value.national_character_set, "AL16UTF16")
  license_model                               = try(each.value.license_model, "BringYourOwnLicense")
  db_version                                  = try(each.value.db_version, "23ai")
  customer_contacts                           = try(each.value.customer_contacts, [])
  open_mode                                   = try(each.value.open_mode, "ReadWrite")
  permission_level                            = try(each.value.permission_level, "Unrestricted")
  whitelisted_ips                             = try(each.value.whitelisted_ips, [])
  tags                                        = try(each.value.tags, { "TF-MOD" = "azure-oracle-adbs" })
  local_dataguard_enabled                     = try(each.value.local_dataguard_enabled, false)
  local_adg_auto_failover_max_data_loss_limit = try(each.value.local_adg_auto_failover_max_data_loss_limit, 0)
}
