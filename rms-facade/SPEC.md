## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
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
| [github_repository_file.custom_logs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.identity_domains](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.instances](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.keys](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.networking](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.nlbs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.service_logs](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.streams](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.tags](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.topics](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.vaults](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [oci_objectstorage_object.compartments](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.custom_logs](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.identity_domains](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.instances](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.keys](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.networking](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.nlbs](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.service_logs](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.streams](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.tags](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.topics](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [oci_objectstorage_object.vaults](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_object) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |
| [github_repository_file.configurations](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository_file) | data source |
| [github_repository_file.dependencies](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository_file) | data source |
| [github_repository_file.url_dependencies](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository_file) | data source |
| [http_http.configurations](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [oci_objectstorage_namespace.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_namespace) | data source |
| [oci_objectstorage_object.configurations](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_object) | data source |
| [oci_objectstorage_object.dependencies](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_object) | data source |
| [oci_objectstorage_object.url_dependencies](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/objectstorage_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration_source"></a> [configuration\_source](#input\_configuration\_source) | The source where configuration files are pulled from. | `string` | `"url"` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | n/a | `string` | `null` | no |
| <a name="input_github_configuration_branch"></a> [github\_configuration\_branch](#input\_github\_configuration\_branch) | n/a | `string` | `null` | no |
| <a name="input_github_configuration_files"></a> [github\_configuration\_files](#input\_github\_configuration\_files) | n/a | `list(string)` | `null` | no |
| <a name="input_github_configuration_repo"></a> [github\_configuration\_repo](#input\_github\_configuration\_repo) | n/a | `string` | `null` | no |
| <a name="input_github_dependency_files"></a> [github\_dependency\_files](#input\_github\_dependency\_files) | The GitHub files containing stack dependencies. | `list(string)` | `null` | no |
| <a name="input_github_file_prefix"></a> [github\_file\_prefix](#input\_github\_file\_prefix) | n/a | `string` | `null` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | n/a | `string` | `null` | no |
| <a name="input_input_config_files_urls"></a> [input\_config\_files\_urls](#input\_input\_config\_files\_urls) | List of URLs that point to the JSON configuration files. | `list(string)` | `null` | no |
| <a name="input_oci_configuration_bucket"></a> [oci\_configuration\_bucket](#input\_oci\_configuration\_bucket) | The OCI Object Storage bucket where Landing Zone configuration files are kept. | `string` | `null` | no |
| <a name="input_oci_configuration_objects"></a> [oci\_configuration\_objects](#input\_oci\_configuration\_objects) | The OCI Object Storage objects containing the Landing Zone configurations. | `list(string)` | `null` | no |
| <a name="input_oci_dependency_objects"></a> [oci\_dependency\_objects](#input\_oci\_dependency\_objects) | The OCI Object Storage objects containing stack dependencies. | `list(string)` | `null` | no |
| <a name="input_oci_object_prefix"></a> [oci\_object\_prefix](#input\_oci\_object\_prefix) | The OCI object prefix. Use this to organize the output and avoid overwriting when you run multiple instances of this stack. The object name is appended to the provided prefix, like oci\_object\_prefix/object\_name. | `string` | `null` | no |
| <a name="input_private_key_password"></a> [private\_key\_password](#input\_private\_key\_password) | n/a | `string` | `null` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |
| <a name="input_save_output"></a> [save\_output](#input\_save\_output) | Whether to save the module output. This is typically done when the output is used as the input to another module. | `bool` | `false` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | n/a | `string` | `null` | no |
| <a name="input_url_dependency_source"></a> [url\_dependency\_source](#input\_url\_dependency\_source) | n/a | `string` | `""` | no |
| <a name="input_url_dependency_source_github_branch"></a> [url\_dependency\_source\_github\_branch](#input\_url\_dependency\_source\_github\_branch) | n/a | `string` | `null` | no |
| <a name="input_url_dependency_source_github_dependency_files"></a> [url\_dependency\_source\_github\_dependency\_files](#input\_url\_dependency\_source\_github\_dependency\_files) | n/a | `list(string)` | `null` | no |
| <a name="input_url_dependency_source_github_repo"></a> [url\_dependency\_source\_github\_repo](#input\_url\_dependency\_source\_github\_repo) | n/a | `string` | `null` | no |
| <a name="input_url_dependency_source_github_token"></a> [url\_dependency\_source\_github\_token](#input\_url\_dependency\_source\_github\_token) | n/a | `string` | `null` | no |
| <a name="input_url_dependency_source_oci_bucket"></a> [url\_dependency\_source\_oci\_bucket](#input\_url\_dependency\_source\_oci\_bucket) | n/a | `string` | `null` | no |
| <a name="input_url_dependency_source_oci_objects"></a> [url\_dependency\_source\_oci\_objects](#input\_url\_dependency\_source\_oci\_objects) | n/a | `list(string)` | `null` | no |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output_string"></a> [output\_string](#output\_output\_string) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
