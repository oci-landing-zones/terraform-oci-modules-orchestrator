# Unreleased - 2.4.0

## Updates

1. Tag defaults in `tags_configuration` can target logical compartments created in the same apply. Governance v0.2.0 separates namespaces and tag definitions from defaults, retaining the existing configuration format. Namespaces and definitions precede compartments; defaults follow compartments.
2. Downstream resources do not wait for tag defaults or their propagation. No default-tag propagation timer or downstream default-tag dependencies are added. Other module versions and existing dependencies are unchanged.

## Upgrade notes

1. A built-in `moved` block transfers existing tag defaults from `module.oci_lz_tags[0]` to `module.oci_lz_tag_defaults[0]`, preserving resource keys and OCI identities without manual state commands. Namespace and tag addresses remain unchanged. External compartment aliases retain their default targets when a managed compartment uses the same key.
2. Resources created before tag defaults take effect may miss those tags, including during the first apply. Defaults do not backfill existing resources on later applies. Configure required tags explicitly through each resource module's tag inputs. Inherited tags absent from a module's configured `defined_tags` can be removed on a later apply.
3. Tag modules reference Governance's `refactor/composable-tags` branch; budgets retain v0.1.6. Review the upgrade plan for unrelated changes; this change does not resolve existing replacement risks from other dependencies or module updates.

# October 26, 2026 Release Notes - 2.3.0

## Breaking changes

1. Upgrading from Orchestrator v2.2.0 changes two legacy Autonomous Database alarm presets through Observability v0.3.0. `adb-cpu-alarm` changes from `CpuUtilization[1m].mean() > 80` to `CpuUtilization[5m].mean() > 85`; `adb-storage-alarm` changes from `StorageUtilization[1m].mean() > 80` to `StorageUtilization[30m].mean() > 85`. Both presets also add the `provider = DBM` freeform tag. These changes affect existing alarms even when no new alarm settings are supplied. Review the longer evaluation windows and higher thresholds before applying.

   To preserve the previous queries, keep each existing alarm key and its destinations, remove `preconfigured_alarm_type`, and configure `supplied_alarm` with `namespace = "oci_autonomous_database"`, `severity = "CRITICAL"`, and the corresponding original query above. Retain the alarm's other configured settings and review the plan before applying; no resource-key or state migration is required for this configuration change.

## Updates

1. Flow-log entries in `logging_configuration.service_logs` can reference configured VCN and subnet keys in `resource_id`, allowing compartments, network targets, log groups and explicit flow logs to be created in one apply. Existing literal OCIDs and other service-log inputs are preserved. Compartment-wide `flow_logs` discovery is unchanged; it does not provide same-apply discovery of newly created targets.

2. All Observability modules now use the published [v0.3.0 release](https://github.com/oci-landing-zones/terraform-oci-modules-observability/releases/tag/v0.3.0). This adds alarm settings, Streaming-to-Logging-Analytics connector fixes, and optional Logging Analytics custom-content imports.
3. Networking updated to the published [v0.9.1 release](https://github.com/oci-landing-zones/terraform-oci-modules-networking/releases/tag/v0.9.1), including DNS steering-policy and private-view RRset fixes, same-module remote-peering region inference, DNS resolver tag inheritance, reserved-public-IP NLB fixes, and optional private NLB IPv4 selection.
4. IAM source URLs now use `oci-landing-zones/terraform-oci-modules-iam`, retaining `v0.3.5`. Security, Governance, OCVS, Workloads (`v0.2.9`), and Exadata references are unchanged. See [Modules Versions](./README.md#mod_versions).

## Upgrade notes

1. Review DNS resolver replacement actions before applying. Networking version-tag updates can defer resolver discovery until apply; provider replacement clears attached views, forwarding rules, and tags before restoring them. An interrupted apply can leave these properties cleared. Resolver tag inheritance can also change policies that use those tags for access control.
2. Setting or changing `assigned_private_ipv4` on an existing NLB requires replacement; review the traffic impact before applying.
3. Streaming-to-Logging-Analytics connectors require `target.log_source_identifier`. For external streams in another compartment whose dependency lacks compartment metadata, set `source.compartment_id`. Imported Logging Analytics custom content survives Terraform destroy; remove unused content through Logging Analytics.

# October 13, 2026, Release Notes - 2.2.0

## Updates

1. Networking updated to [v0.8.5](https://github.com/oci-landing-zones/terraform-oci-modules-networking/releases/tag/v0.8.5) and Workloads to [v0.2.9](https://github.com/oci-landing-zones/terraform-oci-modules-workloads/releases/tag/v0.2.9). Network configuration, third-party firewall compute instances, and private NLBs can now be deployed in one Terraform apply; separate preliminary and final network configurations are no longer required.
2. Compute and NLB modules use the Networking foundation output, while same-stack NLB private IPs are supplied to Networking for route-target resolution.
3. NLB backends can refer to a workload private IP with `target_id`: use `<instance-key>` for a primary VNIC or `<instance-key>.<vnic-key>` for a secondary VNIC. Existing literal `ip_address` backends and OCID-based targets remain supported.
4. `instances_output.json` retains its existing `instances` and `secondary_vnics` maps and additively includes `primary_private_ip_targets`. This map contains canonical private-IP OCIDs for primary VNICs keyed as `<instance-key>` and secondary VNICs keyed as `<instance-key>.<vnic-key>`; RMS Facade also reads both maps from dependency files.

## Upgrade notes

1. No orchestrator-level state moves are required. Networking v0.8.5 performs 11 internal whole-resource moves; review the first upgrade plan before applying.
2. OCI Terraform Provider 7.27.0 or later is required by Networking v0.8.5. Existing literal backend IP addresses and private-IP OCIDs continue to work and do not require migration.
3. Existing deployments that replace literal firewall private-IP references with managed symbolic targets must use two separate plan/apply cycles:
   1. **Phase 1 — module upgrade:** upgrade the modules without changing any existing NLB backend selector or route target. Keep current `ip_address` values, symbolic instance keys and literal OCIDs in `target_id`, and literal private-IP OCIDs in route-rule `network_entity_id`. Require a plan with no backend, route-table, route-target, or attachment replacement, then apply it. This records the new Workloads private-IP lookups in state.
   2. **Phase 2 — symbolic migration:** replace selected private-IP backend references with keys that resolve to their canonical private-IP OCIDs, such as `<instance-key>.<vnic-key>` for secondary VNICs. Any alias already present in `instances_dependency` retains its target; keep a literal private-IP OCID if the corresponding key would select an instance instead. When desired, replace literal NLB private-IP route targets with the NLB key in `network_entity_id`. Require every symbolic value to resolve during planning to the exact existing private-IP OCID, every NLB backend and traffic-path route to be `no-op`, and no route target to be unknown before applying. Keep existing instance-OCID targets unchanged; changing them to private-IP targets changes the backend identity and requires replacement.

   Do not combine these phases for an existing deployment. Before Phase 1 has populated state, Terraform can defer the new private-IP lookups and conservatively plan backend replacement and unknown route updates. Literal `ip_address` and private-IP OCID configurations remain supported and do not have to be migrated. Keep the existing root networking module address and configuration keys. The Phase 1 plan should show state moves for ten route-table collections and one attachment collection, with no infrastructure replacement. Subnet associations continue to use `route_table_key`; without a key, the subnet retains its VCN default route table. A standalone subnet `route_table_id` does not change that association.
3. Subnets are created on the VCN default route table and completed through an attachment. Fresh deployments can have a short default-route interval; route-table reassignment and NLB/private-IP or firewall replacement can interrupt traffic.

# September 22, 2026 Release Notes - 2.1.4

## Updates

1. Exadata Database, Autonomous Database, and Autonomous Recovery Service now reference the `release-1.2.0` module branch. Workload-specific dependency resolution and validation remain owned by the backing modules.
2. Added the root `exadata_database_dependency` input. It accepts the module-native dependency object or a `cloud_exadata_database_output.json` file path and passes the normalized object to Exadata Database.
3. RMS Facade now loads the five Exadata Database dependency families from JSON or YAML dependency files for multi-stack VM Cluster, DB Home, CDB, and PDB chaining.
4. Exadata Database now receives `kms_dependency`, allowing DB Home and CDB `kms_key_id` values to use logical keys from `keys_output.json` as well as literal key OCIDs.
5. Autonomous Database now receives `vaults_dependency` as well as `kms_dependency`, including vaults created in the same Orchestrator stack.
6. Root and RMS Exadata and Autonomous Database outputs now preserve the backing modules' native dependency shapes.
7. Added the root `autonomous_recovery_service_configuration` and `recovery_service_dependency` inputs and the module-owned `autonomous_recovery_service_resources` output for Recovery Service subnets and protection policies.
8. Exadata Database CDBs can resolve DBRS protection-policy keys from Autonomous Recovery Service resources created in the same stack or from a separate stack's canonical dependency artifact.
9. RMS Facade loads Autonomous Recovery Service configuration and dependencies from JSON or YAML and persists `autonomous_recovery_service_output.json` or `.yaml` to the local file system, GitHub, or OCI Object Storage.
10. IAM module references updated to [v0.3.5](https://github.com/oci-landing-zones/terraform-oci-modules-iam/releases/tag/v0.3.5). Requestable identity domain groups are now disabled by default. Existing landing-zone-managed groups that need to be updated must be changed manually in the OCI Console by disabling **User can request access** for each group.

## Bug Fixes

1. RMS output persistence no longer drops module-owned metadata such as `compartment_id` from Exadata DB Homes and VM Clusters or from Autonomous Databases.
2. [Issue #67](https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator/issues/67): Compartment creation now waits 10 seconds for newly created tags to propagate before applying `defined_tags`, preventing tag propagation timing failures.
3. [Issue #66](https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator/issues/66): Vault dependency output files from both the root module and RMS facade now include each vault's `id` alongside its `management_endpoint`, and the orchestrator translates that canonical shape for the security module when creating keys in existing vaults. Generated files can therefore be consumed by downstream stacks without an `Unsupported attribute` or vault dependency schema failure. Previously generated endpoint-only files must be regenerated.
4. [Issue #63](https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator/issues/63): Network dependency normalization now projects newly provisioned networking resources to stable dependency shapes before merging them with external dependencies. This prevents `Inconsistent conditional result types` failures when adding resources such as a spoke subnet to an existing network. Existing external-dependency validation, missing-output guards, merge precedence, RPC region fallback, and DNS view `ocid` compatibility are preserved.
5. [Issue #60](https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator/issues/60): The RMS facade now prefers the canonical OKE keys `oke_clusters_configuration` and `oke_workers_configuration`, while continuing to accept the legacy `clusters_configuration` and `workers_configuration` keys for backward compatibility. The legacy keys are deprecated and should be migrated before the next major release.

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
