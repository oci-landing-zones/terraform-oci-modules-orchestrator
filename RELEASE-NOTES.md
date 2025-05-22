# May 22, 2025 Release Notes - 2.0.7
## Updates
1. Bug fix: _nlbs\_output_ base output set with "id" attribute, now aligned with the reading in _nlbs\_dependency_ local variable.
2. Supporting modules updated. See [Modules Versions](./README.md#mod-versions) for details.


# February 12, 2025 Release Notes - 2.0.6
## Updates
1. Bug fix: _nlbs\_output_ output in *rms_facade* set with "id" attribute, now aligned with the reading in _nlbs\_dependency_ local variable.
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
1. This repository has been moved to the OCI Landing Zones GitHub organization and renamed. It's new location is now  https://github.com/oci-landing-zones/terraform-oci-modules-orchestrator
2. The following supporting Landing Zone repositories have also been moved and renamed:

Repository       | Old Location                                                                      | New Location                                                            
-----------------|-----------------------------------------------------------------------------------|-------------------------------------------------------------------------
Networking       | https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking    | https://github.com/oci-landing-zones/terraform-oci-modules-networking   
Security         | https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security      | https://github.com/oci-landing-zones/terraform-oci-modules-security     
Observability    | https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability | https://github.com/oci-landing-zones/terraform-oci-modules-observability
Governance       | https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance    | https://github.com/oci-landing-zones/terraform-oci-modules-governance   
Secure Workloads | https://github.com/oracle-quickstart/terraform-oci-secure-workloads               | https://github.com/oci-landing-zones/terraform-oci-modules-workloads    


# July 26, 2024 Release Notes - 2.0.2
## Updates    
1. Aligned README.md structure to Oracle's GitHub organizations requirements.


# May 24, 2024 Release Notes - 2.0.1
### Updates
1. Now supporting saving outputs when configuration files are obtained from plain public URLs. The outputs can be saved to private Git Hub repositories or private OCI buckets. The UI has been re-organized.


# April 18, 2024 Release Notes - 2.0.0
### New
1. New OCI Landing Zones Orchestrator version, supporting remote JSON, YAML documents or HCL objects as inputs. The documents can be pulled from private Git Hub repositories, private OCI buckets or any reachable plain URLs.
