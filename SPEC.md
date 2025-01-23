## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oci_lz_alarms"></a> [oci\_lz\_alarms](#module\_oci\_lz\_alarms) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//alarms | v0.2.1 |
| <a name="module_oci_lz_budgets"></a> [oci\_lz\_budgets](#module\_oci\_lz\_budgets) | git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//budgets | release-0.1.4 |
| <a name="module_oci_lz_cloud_guard"></a> [oci\_lz\_cloud\_guard](#module\_oci\_lz\_cloud\_guard) | git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//cloud-guard | v0.2.0 |
| <a name="module_oci_lz_compartments"></a> [oci\_lz\_compartments](#module\_oci\_lz\_compartments) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//compartments | v0.2.7 |
| <a name="module_oci_lz_compute"></a> [oci\_lz\_compute](#module\_oci\_lz\_compute) | git::https://github.com/oci-landing-zones/terraform-oci-modules-workloads.git//cis-compute-storage | v0.1.9 |
| <a name="module_oci_lz_dynamic_groups"></a> [oci\_lz\_dynamic\_groups](#module\_oci\_lz\_dynamic\_groups) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//dynamic-groups | v0.2.7 |
| <a name="module_oci_lz_events"></a> [oci\_lz\_events](#module\_oci\_lz\_events) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//events | v0.2.1 |
| <a name="module_oci_lz_groups"></a> [oci\_lz\_groups](#module\_oci\_lz\_groups) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//groups | v0.2.7 |
| <a name="module_oci_lz_home_region_events"></a> [oci\_lz\_home\_region\_events](#module\_oci\_lz\_home\_region\_events) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//events | v0.2.1 |
| <a name="module_oci_lz_identity_domains"></a> [oci\_lz\_identity\_domains](#module\_oci\_lz\_identity\_domains) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//identity-domains | v0.2.7 |
| <a name="module_oci_lz_logging"></a> [oci\_lz\_logging](#module\_oci\_lz\_logging) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//logging | v0.2.1 |
| <a name="module_oci_lz_network"></a> [oci\_lz\_network](#module\_oci\_lz\_network) | git::https://github.com/oci-landing-zones/terraform-oci-modules-networking.git | v0.7.2 |
| <a name="module_oci_lz_nlb"></a> [oci\_lz\_nlb](#module\_oci\_lz\_nlb) | git::https://github.com/oci-landing-zones/terraform-oci-modules-networking.git//modules/nlb | v0.7.2 |
| <a name="module_oci_lz_notifications"></a> [oci\_lz\_notifications](#module\_oci\_lz\_notifications) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//notifications | v0.2.1 |
| <a name="module_oci_lz_policies"></a> [oci\_lz\_policies](#module\_oci\_lz\_policies) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//policies | v0.2.7 |
| <a name="module_oci_lz_scanning"></a> [oci\_lz\_scanning](#module\_oci\_lz\_scanning) | git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//vss | v0.2.0 |
| <a name="module_oci_lz_security_zones"></a> [oci\_lz\_security\_zones](#module\_oci\_lz\_security\_zones) | git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//security-zones | v0.2.0 |
| <a name="module_oci_lz_service_connectors"></a> [oci\_lz\_service\_connectors](#module\_oci\_lz\_service\_connectors) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//service-connectors | v0.2.1 |
| <a name="module_oci_lz_streams"></a> [oci\_lz\_streams](#module\_oci\_lz\_streams) | git::https://github.com/oci-landing-zones/terraform-oci-modules-observability.git//streams | v0.2.1 |
| <a name="module_oci_lz_tags"></a> [oci\_lz\_tags](#module\_oci\_lz\_tags) | git::https://github.com/oci-landing-zones/terraform-oci-modules-governance.git//tags | release-0.1.4 |
| <a name="module_oci_lz_vaults"></a> [oci\_lz\_vaults](#module\_oci\_lz\_vaults) | git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//vaults | v0.2.0 |
| <a name="module_oci_lz_zpr"></a> [oci\_lz\_zpr](#module\_oci\_lz\_zpr) | git::https://github.com/oci-landing-zones/terraform-oci-modules-security.git//zpr | v0.2.0 |

## Resources

| Name | Type |
|------|------|
| [local_file.compartments_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.custom_logs_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.identity_domains_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.instances_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.keys_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.network_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.nlbs_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.service_logs_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.streams_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.tags_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.topics_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.vaults_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [oci_objectstorage_bucket.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket) | resource |
| [oci_identity_regions.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_identity_tenancy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |
| [oci_objectstorage_namespace.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms_configuration"></a> [alarms\_configuration](#input\_alarms\_configuration) | n/a | `any` | `null` | no |
| <a name="input_budgets_configuration"></a> [budgets\_configuration](#input\_budgets\_configuration) | n/a | `any` | `null` | no |
| <a name="input_cloud_guard_configuration"></a> [cloud\_guard\_configuration](#input\_cloud\_guard\_configuration) | n/a | `any` | `null` | no |
| <a name="input_compartments_configuration"></a> [compartments\_configuration](#input\_compartments\_configuration) | n/a | `any` | `null` | no |
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | n/a | `any` | `null` | no |
| <a name="input_dynamic_groups_configuration"></a> [dynamic\_groups\_configuration](#input\_dynamic\_groups\_configuration) | n/a | `any` | `null` | no |
| <a name="input_events_configuration"></a> [events\_configuration](#input\_events\_configuration) | n/a | `any` | `null` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | n/a | `string` | `null` | no |
| <a name="input_functions_dependency"></a> [functions\_dependency](#input\_functions\_dependency) | n/a | `any` | `null` | no |
| <a name="input_groups_configuration"></a> [groups\_configuration](#input\_groups\_configuration) | n/a | `any` | `null` | no |
| <a name="input_home_region_events_configuration"></a> [home\_region\_events\_configuration](#input\_home\_region\_events\_configuration) | n/a | `any` | `null` | no |
| <a name="input_identity_domain_applications_configuration"></a> [identity\_domain\_applications\_configuration](#input\_identity\_domain\_applications\_configuration) | n/a | `any` | `null` | no |
| <a name="input_identity_domain_dynamic_groups_configuration"></a> [identity\_domain\_dynamic\_groups\_configuration](#input\_identity\_domain\_dynamic\_groups\_configuration) | n/a | `any` | `null` | no |
| <a name="input_identity_domain_groups_configuration"></a> [identity\_domain\_groups\_configuration](#input\_identity\_domain\_groups\_configuration) | n/a | `any` | `null` | no |
| <a name="input_identity_domain_identity_providers_configuration"></a> [identity\_domain\_identity\_providers\_configuration](#input\_identity\_domain\_identity\_providers\_configuration) | n/a | `any` | `null` | no |
| <a name="input_identity_domains_configuration"></a> [identity\_domains\_configuration](#input\_identity\_domains\_configuration) | n/a | `any` | `null` | no |
| <a name="input_instances_configuration"></a> [instances\_configuration](#input\_instances\_configuration) | n/a | `any` | `null` | no |
| <a name="input_instances_dependency"></a> [instances\_dependency](#input\_instances\_dependency) | n/a | `any` | `null` | no |
| <a name="input_kms_dependency"></a> [kms\_dependency](#input\_kms\_dependency) | n/a | `any` | `null` | no |
| <a name="input_logging_configuration"></a> [logging\_configuration](#input\_logging\_configuration) | n/a | `any` | `null` | no |
| <a name="input_logging_dependency"></a> [logging\_dependency](#input\_logging\_dependency) | n/a | `any` | `null` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | n/a | `any` | `null` | no |
| <a name="input_network_dependency"></a> [network\_dependency](#input\_network\_dependency) | n/a | `any` | `null` | no |
| <a name="input_nlb_configuration"></a> [nlb\_configuration](#input\_nlb\_configuration) | n/a | `any` | `null` | no |
| <a name="input_nlbs_dependency"></a> [nlbs\_dependency](#input\_nlbs\_dependency) | n/a | `any` | `null` | no |
| <a name="input_notifications_configuration"></a> [notifications\_configuration](#input\_notifications\_configuration) | n/a | `any` | `null` | no |
| <a name="input_object_storage_configuration"></a> [object\_storage\_configuration](#input\_object\_storage\_configuration) | n/a | `any` | `null` | no |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | n/a | `string` | `null` | no |
| <a name="input_policies_configuration"></a> [policies\_configuration](#input\_policies\_configuration) | n/a | `any` | `null` | no |
| <a name="input_private_key_password"></a> [private\_key\_password](#input\_private\_key\_password) | n/a | `string` | `null` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |
| <a name="input_scanning_configuration"></a> [scanning\_configuration](#input\_scanning\_configuration) | n/a | `any` | `null` | no |
| <a name="input_security_zones_configuration"></a> [security\_zones\_configuration](#input\_security\_zones\_configuration) | n/a | `any` | `null` | no |
| <a name="input_service_connectors_configuration"></a> [service\_connectors\_configuration](#input\_service\_connectors\_configuration) | n/a | `any` | `null` | no |
| <a name="input_streams_configuration"></a> [streams\_configuration](#input\_streams\_configuration) | n/a | `any` | `null` | no |
| <a name="input_streams_dependency"></a> [streams\_dependency](#input\_streams\_dependency) | n/a | `any` | `null` | no |
| <a name="input_tags_configuration"></a> [tags\_configuration](#input\_tags\_configuration) | n/a | `any` | `null` | no |
| <a name="input_tags_dependency"></a> [tags\_dependency](#input\_tags\_dependency) | n/a | `any` | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | User Credentials | `string` | `null` | no |
| <a name="input_topics_dependency"></a> [topics\_dependency](#input\_topics\_dependency) | n/a | `any` | `null` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | n/a | `string` | `null` | no |
| <a name="input_vaults_configuration"></a> [vaults\_configuration](#input\_vaults\_configuration) | n/a | `any` | `null` | no |
| <a name="input_vaults_dependency"></a> [vaults\_dependency](#input\_vaults\_dependency) | n/a | `any` | `null` | no |
| <a name="input_zpr_configuration"></a> [zpr\_configuration](#input\_zpr\_configuration) | n/a | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compute_resources"></a> [compute\_resources](#output\_compute\_resources) | Provisioned compute resources |
| <a name="output_governance_resources"></a> [governance\_resources](#output\_governance\_resources) | Provisioned governance resources |
| <a name="output_iam_resources"></a> [iam\_resources](#output\_iam\_resources) | Provisioned identity resources |
| <a name="output_network_resources"></a> [network\_resources](#output\_network\_resources) | Provisioned networking resources |
| <a name="output_nlb_resources"></a> [nlb\_resources](#output\_nlb\_resources) | Provisioned NLB resources |
| <a name="output_observability_resources"></a> [observability\_resources](#output\_observability\_resources) | Provisioned streaming resources |
| <a name="output_security_resources"></a> [security\_resources](#output\_security\_resources) | Provisioned security resources |
