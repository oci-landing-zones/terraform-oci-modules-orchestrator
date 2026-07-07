# Next release notes

## Breaking Changes

1. OKE configuration files consumed by the RMS facade must use `oke_clusters_configuration` and `oke_workers_configuration` instead of `clusters_configuration` and `workers_configuration`. See [Issue #60](https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator/issues/60).

# July 7, 2026 Release Notes - 2.1.3

## Breaking Changes

1. The minimum supported OCI Terraform Provider version is now 6.29.0, as required by the Compute and Storage module in Workloads v0.2.8. Deployments locked to an older provider must run `terraform init -upgrade` and review the resulting plan before applying.

## Updates

1. Route tables created by the Networking module are now included in network dependency outputs and can be consumed by OCVS configurations. See [PR #59](https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator/pull/59).
2. Networking updated to [v0.8.3](https://github.com/oci-landing-zones/terraform-oci-modules-networking/releases/tag/v0.8.3), adding reserved private IP creation and allowing private Load Balancers to resolve reserved private IP keys from dependencies. Changing a reserved private IP on an existing Load Balancer remains subject to OCI/provider update behavior and may require Load Balancer replacement.
3. Workloads updated to [v0.2.8](https://github.com/oci-landing-zones/terraform-oci-modules-workloads/releases/tag/v0.2.8), adding instance creation and updates from existing or restored boot volumes, custom Block Volume backup policies, File Storage quotas, and managed OKE node pool metadata. Changing an existing instance's boot volume source replaces its attached boot volume; schedule downtime and preserve the replaced volume unless it can safely be deleted. OCI Terraform Provider 8.21.0 and earlier cannot toggle quota enforcement on an existing file system; use the workaround documented by the Workloads module.
4. Module references updated. See [Modules Versions](./README.md#mod_versions) for details.

## Bug Fixes

1. OCVS network dependencies now translate canonical NSG and route table `{ id }` entries into the resource-specific attributes expected by OCVS v1.1.0. This supports both resources created by the orchestrator and externally supplied dependencies.
2. Networking v0.8.3 fixes reserved private IP resolution for private Load Balancers.
3. Networking v0.8.3 makes both NSG ingress and egress rules recognize `objectstorage` and `all-services`; other values continue to pass through to the OCI API unchanged.

# June 11, 2026 Release Notes - 2.1.2

## Updates

1. Native workload integration added for the Cloud Exadata Database and Autonomous Database modules from `terraform-oci-modules-exadata`.
2. Added `cloud_exadata_database_configuration` and `autonomous_databases_configuration` inputs, plus `subscription_dependency` and `databases_dependency`.
3. Added output persistence for `cloud_exadata_database_output` and `autonomous_databases_output` in the base module and `rms-facade`, including JSON and YAML output formats in `rms-facade`. `cloud_exadata_database_output` is emitted for inventory and future dependency handoff; Exadata resources in downstream stacks still require literal OCIDs with `terraform-oci-modules-exadata` v1.1.0.
4. Documented Autonomous Database TDE/KMS usage: Oracle-managed encryption needs no TDE vault/key fields; customer-managed encryption should use a literal Vault OCID, while encryption keys may use OCIDs or `keys_output.json` / `kms_dependency`.
5. Modules references updated. See [Modules Versions](./README.md#modules-versions) for details.

# May 15, 2026 Release Notes - 2.1.1

## Updates

1. Bug fix: _oci_lz_identity_domains_ is now invoked when identity domain groups, dynamic groups, identity providers, or applications are configured without _identity_domains_configuration_. This supports multi-stack deployments that create resources in existing identity domains through dependencies.
2. _identity_domains_dependency_ input added in the base module and _rms-facade_, enabling identity domain dependencies from JSON or YAML dependency files.
3. Identity domain groups and dynamic groups are now exposed in _iam_resources_. _identity_domains_output_ is written only when the stack creates identity domains.
4. OKE outputs now include worker nodes in both base module outputs and _rms-facade_ output files.
5. Policy creation now waits for IAM group propagation before creating policies that may reference groups.
6. Supporting modules updated. Workloads module updated to _v0.2.7_, Networking module updated to _v0.8.2_, and Observability module updated to _v0.2.6_. Networking update includes Private Service Access support, RPC _region_name_ outputs, Network Load Balancer DNS health checks, and upstream fixes. See [Modules Versions](./README.md#modules-versions) for details.

# March 25, 2026 Release Notes - 2.1.0

## Updates

1. Support for OCVS deployments.
2. Full support for YAML-based configuration files, including YAML-based dependency files.
3. *rms-facade* module is now the common module for RMS and Terraform CLI based deployments. See [Deploying with OCI Resource Manager Service (RMS)](./README.md#deploying-with-oci-resource-manager-service-rms) and [Deploying with Terraform CLI](./README.md#deploying-with-terraform-cli).
4. [Modules references](./README.md#modules-versions) updated. 
5. LB support added to dependency output.
6. Bug fix for storage_configuration not passed to compute.

# February 9, 2026 Release Notes - 2.0.11

## Updates

1. Update Workloads Module to 2.0.3

# December 3, 2025 Release Notes - 2.0.9

## Updates

1. Update Governance Module

# August 26, 2025 Release Notes - 2.0.8

## Updates

1. Support for OKE (Oracle Kubernetes Engine) added. See [workloads.tf](./workloads.tf)
2. Supporting modules updated. See [Modules Versions](./README.md#mod-versions) for details.

# May 22, 2025 Release Notes - 2.0.7

## Updates

1. Bug fix: _nlbs\_output_ base output set with "id" attribute, now aligned with the reading in _nlbs\_dependency_ local variable.
2. Supporting modules updated. See [Modules Versions](./README.md#mod-versions) for details.

# February 12, 2025 Release Notes - 2.0.6

## Updates

1. Bug fix: _nlbs\_output_ output in _rms_facade_ set with "id" attribute, now aligned with the reading in _nlbs\_dependency_ local variable.
2. Support for [OCI Bastion module](https://github.com/oci-landing-zones/terraform-oci-modules-security/tree/main/bastion) added in [security.tf](./security.tf).
3. Supporting modules updated. See [Modules Versions](./README.md#mod-versions) for details.

# November 19, 2024 Release Notes - 2.0.5

## Updates

1. Bug fix: _var.save_output_ removed from Object Storage namespace check, thus making it really optional for stacks not requiring any outputs.

# November 05, 2024 Release Notes - 2.0.4

## Updates

1. Support added for ZPR attributes and policies.
2. Supporting modules updated. See [Modules Versions](./README.md#mod_versions) for details.

# August 07, 2024 Release Notes - 2.0.3

## Updates

1. This repository has been moved to the OCI Landing Zones GitHub organization and renamed. It's new location is now  <https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator>
2. The following supporting Landing Zone repositories have also been moved and renamed:

Repository       | Old Location                                                                      | New Location
-----------------|-----------------------------------------------------------------------------------|-------------------------------------------------------------------------
Networking       | <https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking>    | <https://github.com/oci-landing-zones/terraform-oci-modules-networking>
Security         | <https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security>      | <https://github.com/oci-landing-zones/terraform-oci-modules-security>
Observability    | <https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability> | <https://github.com/oci-landing-zones/terraform-oci-modules-observability>
Governance       | <https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance>    | <https://github.com/oci-landing-zones/terraform-oci-modules-governance>
Secure Workloads | <https://github.com/oracle-quickstart/terraform-oci-secure-workloads>               | <https://github.com/oci-landing-zones/terraform-oci-modules-workloads>

# July 26, 2024 Release Notes - 2.0.2

## Updates

1. Aligned README.md structure to Oracle's GitHub organizations requirements.

# May 24, 2024 Release Notes - 2.0.1

### Updates

1. Now supporting saving outputs when configuration files are obtained from plain public URLs. The outputs can be saved to private Git Hub repositories or private OCI buckets. The UI has been re-organized.

# April 18, 2024 Release Notes - 2.0.0

### New

1. New OCI Landing Zones Orchestrator version, supporting remote JSON, YAML documents or HCL objects as inputs. The documents can be pulled from private Git Hub repositories, private OCI buckets or any reachable plain URLs.
