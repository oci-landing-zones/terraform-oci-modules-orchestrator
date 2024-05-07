# OCI Landing Zones Orchestrator

![Landing_Zone_Logo](images/landing%20zone_300.png)

[![Deploy_To_OCI](images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/terraform-oci-landing-zones-orchestrator/archive/refs/heads/main.zip)<br>
*If you are logged into your OCI tenancy in the Commercial Realm (OC1), the button will take you directly to OCI Resource Manager where you can proceed to deploy. If you are not logged, the button takes you to Oracle Cloud initial page where you must enter your tenancy name and login to OCI.*
<br>

## Introduction

The OCI Landing Zones Orchestrator is a generic Terraform module that orchestrates the creation of Landing Zone architectures expressed in a single or multiple configuration files, that can be JSON documents, YAML documents or contain HCL (Hashicorp Language) object declarations. These configurations **must** be defined according to the specifications and requirements set forth by the OCI Landing Zone core modules, that are available in the following repositories:

- [Identity & Access Management](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam)
- [Networking](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking)
- [Governance](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance)
- [Security](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security)
- [Observability & Monitoring](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability)
- [Secure Workloads](https://github.com/oracle-quickstart/terraform-oci-secure-workloads)

Such approach allows for the build out of custom Landing Zones in a declarative fashion, without any Terraform coding knowledge.

**Note:** users of the [legacy Orchestrator](https://github.com/oracle-quickstart/terraform-oci-open-lz/tree/master/orchestrator) please check [UPGRADE.md](./UPGRADE.md) for upgrading your stack to this new Orchestrator version.

## Requirements

### IAM Permissions

The permissions to execute the Orchestrator are determined by the configurations that are given as inputs. Therefore each Orchestrator instance may require different IAM policies. Refer to the policy requirements of each module that backs up the provided configurations. For example, if the configurations contains *compartments_configuration* and *network_configuration*, the Orchestrator instance requires the permissions required by [Compartments](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/compartments) and [Networking](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking) modules.

### Terraform Version < 1.3.x and Optional Object Type Attributes
The Orchestrator underlying modules rely on [Terraform Optional Object Type Attributes feature](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes), which is experimental from Terraform 0.14.x to 1.2.x. It shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes. The feature has been promoted and it is no longer experimental in Terraform 1.3.x.

**As of April 2024, the Orchestrator can only be used with Terraform versions up to 1.2.x**, because it can be deployed using the [OCI Resource Manager service](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/home.htm), that still does not support Terraform 1.3.x.

Upon running *terraform plan* with Terraform versions prior to 1.3.x, Terraform displays the following harmless warning:
```
Warning: Experimental feature "module_variable_optional_attrs" is active
```

## External Dependencies

Landing Zones can be expressed in a single configuration or split in multiple separate configurations potentially managed by different teams. Separate configurations require the usage of the output of one configuration as the input of another. The classic example is consuming compartments in other configurations, like networking. Other examples are consuming networking resources in Compute instances, or consuming encryption keys in Block volumes. There are many other dependencies examples.

To account for these scenarios, the Orchestrator can generate and intake dependency files. The required dependencies for a given Orchestrator instance depends on what is expressed in its input configurations. For example, if you refer to a compartment key (instead of an OCID) in the *compartment_id* attribute of *network_configuration*, the *compartments_dependency* variable is required. If you refer to a subnet key (instead of an OCID) in the *subnet_id* attribute of *instances_configuration*, the *network_dependency* variable is required. Each underlying module specifies its supported dependencies, and the Orchestrator figures out the dependency files to generate for further consumption by other Orchestrator instances.

Below are the output file names that are generated for the respective configuration that can be used as a dependency:

Configuration | Output File Name
--------------|------------------
compartments_configuration | compartments_output.json
network_configuration | network_output.json
nlb_configuration | nlbs_output.json
notifications_configuration | topics_output.json
streams_configuration | streams.output.json
logging_configuration | service_logs_output.json and custom_logs_output.json
vaults_configuration | vaults_output.json and keys_output.json
tags_configuration | tags_output.json
instances_configuration | instances_output.json

## How to Invoke the Orchestrator

Before anything, have your configurations (and dependencies, if any) ready and accessible. This repository has sample configurations in [*./examples/vision/iam/config*](./examples/vision/iam/config) and [*./examples/vision/network/config*](./examples/vision/network/config) folders. 

An extensive catalog of configurations is available in the [Operating Entities Landing Zones repository](https://github.com/oracle-quickstart/terraform-oci-open-lz/tree/master/examples).

### Deploying with OCI Resource Manager Service (RMS)

The Orchestrator provides an [RMS Facade](./rms-facade/) module allowing for the usage of configuration files stored in private GitHub repositories, private OCI buckets or plain URLs. Dependencies can also be consumed from GitHub repositories and OCI buckets.

The table below summarizes the supported combinations of configurations and dependencies sources:

Configurations Source         | Configuration Files Formats | Dependencies Sources                          | Dependency Files Formats | Requirements 
------------------------------|-----------------------------| ----------------------------------------------|------------------------- | ------------ 
Private GitHub repository     | JSON, YAML                  | Same private GitHub repository                | JSON                     | GitHub token with read/(write, if saving output) access permissions on the private GitHub repository. 
Private OCI bucket            | JSON, YAML                  | Same private OCI bucket                       | JSON                     | OCI IAM permissions to read/(write, if saving output) to the private OCI bucket. 
Plain Public URLs             | JSON, YAML                  | Private GitHub repository, private OCI bucket | JSON                     | URLs are reachable. Read/(write, if saving output) access permissions to private GitHub repository or private OCI bucket

Steps 1-10 below shows how to deploy with RMS. The stack is one concrete Orchestrator example with all variables pre-filled, and it can be changed depending on where your configuration files are located and which system (GitHub or OCI bucket) you want to utilize for dependencies. 

**FOR RUNNING THE EXAMPLE AS-IS, A PRE-EXISTING PRIVATE BUCKET NAMED "terraform-runtime-bucket" IS REQUIRED.**

1. Click [![Deploy_To_OCI](./images/DeployToOCI.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/terraform-oci-landing-zones-orchestrator/archive/refs/heads/urls-dep-source.zip&zipUrlVariables={"input_config_files_urls":"https://raw.githubusercontent.com/oracle-quickstart/terraform-oci-landing-zones-orchestrator/main/examples/vision/iam/config/iam-config.json","url_dependency_source_oci_bucket":"terraform-runtime-bucket","url_dependency_source":"ocibucket","save_output":true,"oci_object_prefix":"iam/output"})

2. Accept terms, wait for the configuration to load. 
3. Set *Working directory* to "terraform-oci-landing-zones-orchestrator-main/rms-facade". 
4. Give the stack a name in the *Name* field.
5. Set *Terraform version* to 1.2.x. Click *Next* button at the bottom of the screen. 

The [screenshot below](#rms-stack-creation) shows how the RMS stack creation screen looks like on step 5.

<a name="rms-stack-creation">![rms-stack-creation](images/rms-stack-creation.png)</a>

6. Upon clicking *Next* button, the *Configure variables* screen is displayed with input variables pre-filled: (see [image below](#rms-stack-input-variables) for an example):
    1. Select or accept the selected deployment *Region* (IAM resources are always automatically deployed in the home region regardless).
    2. In *Input Files* section, select the *Configurations Source*. Each supported source has distinct input fields, but all of them have *Configuration Files* (Required) and *Dependency Files* (Optional). The example has the following fields:
        - *Configurations Source*: "url", which means any URL in the *Configuration Files* field must be publicly available.
        - *Configuration Files*: "https://raw.githubusercontent.com/oracle-quickstart/terraform-oci-landing-zones-orchestrator/main/examples/vision/iam/config/iam-config.json", that happens to be available in this public GitHub repository.
        - *Dependencies Source for URL-based Configurations*: "ocibucket", which means dependency files are read and written to an OCI private bucket.
        - *OCI Bucket Name*: "terraform-runtime-bucket", the bucket name where dependency files are read and written to. **THE BUCKET IS NOT CREATED BY THE ORCHESTRATOR.**
        - *Dependency Files*: empty, which means the specified configuration files stack do not rely on any dependencies.
    3. In *Output Files* section, the following fields are pre-filled:
        - *Save Output?* option is checked, which means the stack output is saved in the same OCI bucket specified for dependency files. The saved file can be subsequently referred as a dependency in *Dependency Files* in another stack. 
        - *OCI Object Prefix*: "iam/output", which gets prepended to the generated file name. In this example, the full file path is "iam/output/compartments_output.json".
    4. Click *Next*.
8. Uncheck *Run apply* option at the bottom of the screen. Click *Create*.
9. Click the *Plan* button.
10. Upon a successfully created plan, click the *Apply* button and pick the created plan in the *Apply job plan resolution* drop down.

The [screenshot below](#rms-stack-creation) shows how the RMS stack variables look like on step 6.3.

<a name="rms-stack-input-variables">![rms-stack-input-variables](images/rms-stack-input-variables.png)</a>

### Deploying with Terraform CLI

In this folder, execute the typical Terraform workflow: *terraform init/plan/apply*.

In the *plan* step, pass in as many configuration files as needed using the *-var-file* option. As a good practice, redirect the state file to another folder or use Terraform workspaces.

In the examples below, the state file is saved in a separate folder via the *-state* option. This way the Orchestrator can be safely executed multiple times with distinct input configurations.

The examples are fully functional. The first *terraform plan/apply* pair provisions an IAM compartments, group and policy. The second *terraform plan/apply* pair consumes the output of the first execution (./examples/vision/iam/config/compartments_output.json) to provision networking resources in the compartment designed for that. 

**Note**: Make sure to add your tenancy connectivity credentials in [*./examples/vision/iam/config/iam-credentials.json*](./examples/vision/iam/config/iam-credentials.json) and [*./examples/vision/network/config/network-credentials.json*](./examples/vision/network/config/network-credentials.json).


#### 1. Provisioning IAM Resources
```
terraform init
```
The *terraform plan* command is broken down in different lines for clarity. Note the line *-var "output_path=./examples/vision/iam/config"*. The optional *output_path* variable specifies where to save the output to. A file is created in that path, and it can be used as a dependency in another Orchestrator instance. The Orchestrator generates the output file depending on the contents of the input configurations. Some configurations will not cause any outputs, as they are not meant to be used as a dependency to any other configuration. 
```
terraform plan \
-var-file ./examples/vision/iam/config/iam-credentials.json \
-var-file ./examples/vision/iam/config/iam-config.json \
-var "output_path=./examples/vision/iam/config" \
-state ./examples/vision/iam/runtime/terraform.tfstate \
-out ./examples/vision/iam/runtime/plan.out
```
```
terraform apply -state ./examples/vision/iam/runtime/terraform.tfstate ./examples/vision/iam/runtime/plan.out
```

#### 2. Provisioning Networking Resources

The *terraform plan* command is broken down in different lines for clarity. Note the line *-var 'compartments_dependency="./examples/vision/iam/config/compartments_output.json"'*. It takes the output file from the IAM Orchestrator instance.
```
terraform plan \
-var-file ./examples/vision/network/config/network-credentials.json \
-var-file ./examples/vision/network/config/network-config.json \
-var 'compartments_dependency="./examples/vision/iam/config/compartments_output.json"' \
-state ./examples/vision/network/runtime/terraform.tfstate \
-out ./examples/vision/network/runtime/plan.out
```
```
terraform apply -state ./examples/vision/network/runtime/terraform.tfstate ./examples/vision/network/runtime/plan.out
```
To destroy the networking resources:
```
terraform apply -destroy -var-file ./examples/vision/network/config/network-credentials.json -state ./examples/vision/network/runtime/terraform.tfstate
```
To destroy the IAM resources:
```
terraform apply -destroy -var-file ./examples/vision/iam/config/iam-credentials.json -state ./examples/vision/iam/runtime/terraform.tfstate
```

## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md).

&nbsp; 

## License
Copyright (c) 2024, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE) for more details.

&nbsp; 

## Known Issues

None.
