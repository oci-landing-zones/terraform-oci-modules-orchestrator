# May 13, 2026 Release Notes - 2.1.1

## Updates

1. Bug fix: _oci_lz_identity_domains_ is now invoked when identity domain groups, dynamic groups, identity providers, or applications are configured without _identity_domains_configuration_. This supports multi-stack deployments that create resources in existing identity domains through dependencies.
2. _identity_domains_dependency_ input added in the base module and _rms-facade_, enabling identity domain dependencies from JSON or YAML dependency files.
3. Identity domain groups and dynamic groups are now exposed in _iam_resources_. _identity_domains_output_ is written only when the stack creates identity domains.
4. OKE outputs now include worker nodes in both base module outputs and _rms-facade_ output files.
5. Policy creation now waits for IAM group propagation before creating policies that may reference groups.
6. Supporting modules updated. Workloads module updated to _v0.2.7_ and Networking module updated to _v0.8.2_. Networking update includes Private Service Access support, RPC _region_name_ outputs, Network Load Balancer DNS health checks, and upstream fixes. See [Modules Versions](./README.md#modules-versions) for details.

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
