## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | < 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oci_orchestrator_compartments"></a> [oci\_orchestrator\_compartments](#module\_oci\_orchestrator\_compartments) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//compartments | v0.1.9 |
| <a name="module_oci_orchestrator_dynamic_groups"></a> [oci\_orchestrator\_dynamic\_groups](#module\_oci\_orchestrator\_dynamic\_groups) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//dynamic-groups | v0.1.9 |
| <a name="module_oci_orchestrator_groups"></a> [oci\_orchestrator\_groups](#module\_oci\_orchestrator\_groups) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//groups | v0.1.9 |
| <a name="module_oci_orchestrator_logging"></a> [oci\_orchestrator\_logging](#module\_oci\_orchestrator\_logging) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//logging | v0.1.3 |
| <a name="module_oci_orchestrator_networking"></a> [oci\_orchestrator\_networking](#module\_oci\_orchestrator\_networking) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking.git | v0.6.4 |
| <a name="module_oci_orchestrator_notifications"></a> [oci\_orchestrator\_notifications](#module\_oci\_orchestrator\_notifications) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//notifications | v0.1.3 |
| <a name="module_oci_orchestrator_policies"></a> [oci\_orchestrator\_policies](#module\_oci\_orchestrator\_policies) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//policies | issue-481-root-cmp-dependency |
| <a name="module_oci_orchestrator_service_connectors"></a> [oci\_orchestrator\_service\_connectors](#module\_oci\_orchestrator\_service\_connectors) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//service-connectors | v0.1.3 |
| <a name="module_oci_orchestrator_streams"></a> [oci\_orchestrator\_streams](#module\_oci\_orchestrator\_streams) | git::https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability.git//streams | v0.1.3 |

## Resources

| Name | Type |
|------|------|
| [oci_identity_regions.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_identity_tenancy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_configuration"></a> [compartments\_configuration](#input\_compartments\_configuration) | n/a | `any` | `null` | no |
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_dynamic_groups_configuration"></a> [dynamic\_groups\_configuration](#input\_dynamic\_groups\_configuration) | n/a | `any` | `null` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | n/a | `string` | `null` | no |
| <a name="input_functions_dependency"></a> [functions\_dependency](#input\_functions\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_groups_configuration"></a> [groups\_configuration](#input\_groups\_configuration) | n/a | `any` | `null` | no |
| <a name="input_kms_dependency"></a> [kms\_dependency](#input\_kms\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_logging_configuration"></a> [logging\_configuration](#input\_logging\_configuration) | n/a | `any` | `null` | no |
| <a name="input_logging_dependency"></a> [logging\_dependency](#input\_logging\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | n/a | `any` | `null` | no |
| <a name="input_networks_dependency"></a> [networks\_dependency](#input\_networks\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_notifications_configuration"></a> [notifications\_configuration](#input\_notifications\_configuration) | n/a | `any` | `null` | no |
| <a name="input_policies_configuration"></a> [policies\_configuration](#input\_policies\_configuration) | n/a | `any` | `null` | no |
| <a name="input_private_key_password"></a> [private\_key\_password](#input\_private\_key\_password) | n/a | `string` | `null` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |
| <a name="input_service_connectors_configuration"></a> [service\_connectors\_configuration](#input\_service\_connectors\_configuration) | n/a | `any` | `null` | no |
| <a name="input_streams_configuration"></a> [streams\_configuration](#input\_streams\_configuration) | n/a | `any` | `null` | no |
| <a name="input_streams_dependency"></a> [streams\_dependency](#input\_streams\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_tags_dependency"></a> [tags\_dependency](#input\_tags\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | User Credentials | `string` | `null` | no |
| <a name="input_topics_dependency"></a> [topics\_dependency](#input\_topics\_dependency) | n/a | `map(any)` | `null` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provisioned_identity_resources"></a> [provisioned\_identity\_resources](#output\_provisioned\_identity\_resources) | Provisioned identity resources |
| <a name="output_provisioned_networking_resources"></a> [provisioned\_networking\_resources](#output\_provisioned\_networking\_resources) | Provisioned networking resources |
| <a name="output_provisioned_streaming_resources"></a> [provisioned\_streaming\_resources](#output\_provisioned\_streaming\_resources) | n/a |
