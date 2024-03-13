## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0, < 1.3.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oci_lz_orchestrator"></a> [oci\_lz\_orchestrator](#module\_oci\_lz\_orchestrator) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [github_repository_file.compartments](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.networking](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.streams](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.topics](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [oci_objectstorage_object.compartments](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.networking](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.streams](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.topics](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |
| [http_http.dependency_files_urls](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.input_config_files_urls](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [oci_objectstorage_namespace.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_namespace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dependency_files_urls"></a> [dependency\_files\_urls](#input\_dependency\_files\_urls) | List of URLs that point to files containing dependencies expressed in the input config files. | `list(string)` | `null` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | n/a | `string` | `null` | no |
| <a name="input_github_branch_name"></a> [github\_branch\_name](#input\_github\_branch\_name) | n/a | `string` | `null` | no |
| <a name="input_github_file_prefix"></a> [github\_file\_prefix](#input\_github\_file\_prefix) | n/a | `string` | `null` | no |
| <a name="input_github_repository_name"></a> [github\_repository\_name](#input\_github\_repository\_name) | n/a | `string` | `null` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | n/a | `string` | `null` | no |
| <a name="input_input_config_files_urls"></a> [input\_config\_files\_urls](#input\_input\_config\_files\_urls) | List of URLs that point to the JSON configuration files. | `list(string)` | `null` | no |
| <a name="input_oci_bucket_name"></a> [oci\_bucket\_name](#input\_oci\_bucket\_name) | The OCI bucket name. The executing user MUST have write permissions on the bucket. | `string` | `null` | no |
| <a name="input_oci_object_prefix"></a> [oci\_object\_prefix](#input\_oci\_object\_prefix) | The OCI object prefix. Use this to organize the output and avoid overwriting when you run multiple instances of this stack. The object name is appended to the provided prefix, like oci\_object\_prefix/object\_name. | `string` | `null` | no |
| <a name="input_output_location"></a> [output\_location](#input\_output\_location) | The location type where the output is saved. Valid values are ocibucket or github. | `string` | `"ocibucket"` | no |
| <a name="input_private_key_password"></a> [private\_key\_password](#input\_private\_key\_password) | n/a | `string` | `null` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |
| <a name="input_save_output"></a> [save\_output](#input\_save\_output) | Whether to save the module output. This is typically done when the output is used as the input to another module. | `bool` | `true` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | n/a | `string` | `null` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compartments_output"></a> [compartments\_output](#output\_compartments\_output) | n/a |
| <a name="output_networking_output"></a> [networking\_output](#output\_networking\_output) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_streams_output"></a> [streams\_output](#output\_streams\_output) | n/a |
| <a name="output_topics_output"></a> [topics\_output](#output\_topics\_output) | n/a |
