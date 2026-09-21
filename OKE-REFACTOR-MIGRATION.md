# OKE Single-Cluster Module Adapter

This development branch adapts the existing orchestrator OKE inputs to the
single-cluster `cis-oke` contract at commit
`036b6eac9e365535dddcdf382a888baaebe635ea`. It is a migration candidate, not
an approved in-place upgrade for existing Terraform state.

## Configuration Boundary

The root inputs remain `oke_clusters_configuration` and
`oke_workers_configuration`. OKE-WE does not need to change its JSON envelopes
or replace the keyed `clusters`, `node_pools`, and `virtual_node_pools` maps.

The Resource Manager facade accepts either the prefixed OKE-WE envelopes or
the older `clusters_configuration` / `workers_configuration` aliases. Supplying
both aliases for the same family is rejected, including explicit null values.
This does not change the facade's existing merging behavior across input files.

The adapter invokes the downstream module once per legacy cluster key:

```text
oke_clusters_configuration.clusters
  CLR-PROD ----> module.oci_lz_oke["CLR-PROD"] ----> one cluster + its pools
  CLR-PREPROD -> module.oci_lz_oke["CLR-PREPROD"] -> one cluster + its pools

oke_workers_configuration
  node_pools / virtual_node_pools
    cluster_id identifies the matching cluster key
```

Pool map keys are retained; managed and virtual pool keys must be globally
distinct. The root `oke_resources` output and `oke_output.json` retain their
`clusters`, `node_pools`, `nodes`, and `virtual_node_pools` maps. Detailed resource
attributes come from the new downstream module; consumers must not assume every
provider-specific attribute is unchanged.

## Input Translation

| Legacy input | New module input |
| --- | --- |
| `clusters.<key>` and cluster defaults | Flat `cluster_configuration` |
| `is_enhanced` | `cluster_type` |
| `networking.services_subnet_id` | `networking.service_lb_subnet_ids` |
| `image_signing.img_kms_key_id` | `image_signing.kms_key_ids` list |
| Pools whose `cluster_id` matches a cluster key | That invocation's `workers_configuration.worker_pools` |
| Managed / virtual pool map | `mode: node-pool` / `virtual-node-pool` |
| `node_config_details.node_shape`, flex settings | `shape`, `ocpus`, `memory` |
| Image OCID | `image_id` |
| Numeric OL version or OKE-WE `9\.[0-9]+` selector | `os_version`, with the OKE-WE selector mapped to `9` |
| Workers / pods subnet and NSG fields | `subnet_id`, `nsg_ids`, `pod_subnet_id`, `pod_nsg_ids` |
| Worker encryption settings | `volume_kms_key_id`, `pv_transit_encryption` |
| OKE-WE `cloud_init.heredoc_script` | Shell-script MIME part, with downstream default bootstrap disabled |
| `node_metadata`, including raw `user_data` | `node_metadata`, with downstream default bootstrap disabled |
| Eviction, cycling, capacity reservation | Corresponding flat worker settings |

Compartment, network, and KMS dependency maps continue to be passed to each
downstream invocation. No network, IAM, Vault, or tagging resources are added
by this adapter.

## Behavior To Review Before Migration

- The candidate supports private, enhanced clusters only. Basic clusters are
  rejected, not silently upgraded. Native clusters must omit Kubernetes
  `pods_cidr`. Exactly one service LB subnet is required by the candidate.
- Pools must reference a cluster in the same input set. Worker-only deployments
  targeting external cluster OCIDs are not supported by this version.
- Pools inherit their cluster compartment and CIS level downstream. The adapter
  rejects mismatching legacy values rather than moving resources or weakening
  CIS requirements. Compartment references must match textually; use the same
  logical key or OCID for cluster and pools.
- Legacy per-object CIS defaults were `1`, even when `default_cis_level` was `2`.
  This adapter preserves that behavior. Set `cis_level` explicitly on both the
  cluster and managed pools for CIS2. Downstream CMEK checks remain active.
- Explicit false encryption values remain false. No new CIS1 encryption default
  is introduced.
- Pool tags can now be inherited by nodes when node tags are absent. This is a
  downstream behavior change that must be reviewed for tag-based IAM effects.
  Explicit differing pool/node tags are rejected by the downstream module.
  Explicit empty maps are retained by the adapter.
- Numeric OS selectors use downstream image selection, not legacy regex
  matching. Pin the current image OCID when validating an existing node pool;
  otherwise a newer image can produce a node-pool update. Arbitrary regexes and
  omitted image selectors are rejected.
- Existing bootstrap content is passed through. The adapter never injects
  additional downstream bootstrap scripts; absent legacy bootstrap remains
  absent. Other custom cloud-init formats need manual conversion.
- Absent managed placement retains AD 1 with automatic fault-domain selection.
  Heterogeneous per-AD fault-domain/preemption settings and explicit virtual
  placement are rejected. Other downstream checks, including pool-size,
  virtual-pool NSG, unique-name, and uniform SSH/transit-encryption requirements,
  remain active.
- The candidate may still show eviction-duration normalization drift (`PT1H`
  versus `PT60M`); this adapter does not change the downstream implementation.

## Existing State Is A Separate Migration

**Do not apply this branch directly to an existing deployment.** The change
from `module.oci_lz_oke[0]` to `module.oci_lz_oke["<cluster-key>"]`, plus the
upstream module nesting, changes Terraform resource addresses.

This branch contains no automatic state moves. Before any existing-state
upgrade, inventory and back up state, pin images and deployed settings, build
an address mapping for each cluster and pool, rehearse on an isolated state
copy, and inspect a fresh plan. Cluster or pool replacement must never be
accepted as an incidental consequence of the refactor. A module-level move
alone is insufficient because the internal resources have also moved.

## Verification

```bash
terraform init -backend=false -input=false
terraform validate
python3 -m unittest discover -s tests -v
terraform -chdir=rms-facade init -backend=false -input=false
terraform -chdir=rms-facade validate
```

The Python tests run provider-free plans for empty, native, overlay, CIS2,
multiple-cluster, virtual-pool, bootstrap, image, tag, and error cases. After
root initialization, the same cases also run through the pinned downstream
configuration module's actual typed inputs. Without initialization those
downstream tests are explicitly skipped. `TERRAFORM_BIN` selects another
Terraform executable, including 1.5.7 for the orchestrator minimum-version
check.

These tests do not contact OCI or prove live provisioning, Kubernetes health,
state migration safety, or absence of post-apply drift. Those remain separate
functional test gates before release.

## Functional Migration Evidence

Review dependency: [workloads migration validation PR #53](https://github.com/oci-landing-zones/terraform-oci-modules-workloads/pull/53),
based on the unpublished `feat/cis-oke-v1.0.0-refactor` branch. The pin is a
development candidate, not a released workloads version.

At the current pin, all 29 adapter/typed-input tests passed on both Terraform
1.16.3 and 1.5.7. Root and Resource Manager facade validation passed, as did
formatting and whitespace checks.

A temporary legacy v0.2.8 enhanced/native CIS1 cluster and one managed pool
were migrated through this adapter using explicit resource-level moved blocks
on Terraform 1.16.3 with OCI provider 8.29.0. The live target was workloads
commit `3733bc306ec34d26295f6773d3c102afa364a711`; the pinned descendant above
adds only checker tests, validation fixes and migration documentation, not
Terraform resource changes.

- Legacy provisioning and the baseline follow-up plan passed.
- A reviewed legacy tag-only preparation aligned pool and future-node template
  tracking tags while preserving existing tags. A new clean baseline was taken.
- The checker explicitly preserved reviewed, unchanged tenancy-default defined
  tags. It now normalizes absent capacity reservations represented as null or
  empty string. Other mismatches remain blocking.
- Migration added four Terraform helper records and updated the cluster/pool
  in place: no OCI resource replacement or deletion.
- Cluster, pool, instance and Kubernetes node identities remained unchanged.
  The worker was Ready and all eight system pods were healthy after migration.
- The subsequent plan passed the checker but was not no-op: the pool still
  reports `PT1H` versus `PT60M` eviction-duration formatting drift. Cluster
  output values also refresh after the update; no cluster resource change
  remained. Do not repeatedly apply this formatting difference as a fix.

This proves the tested native managed-pool path only, not arbitrary existing
estates, virtual-pool migration or application continuity under load. Existing
workers were not cycled and retained their prior metadata endpoint setting;
IMDSv2 adoption requires a separate reviewed cycling/replacement operation.
The shared prod/preprod functional clusters were outside the migration state.

For tag preparation and `--preserve-defined-tag`, follow the pinned workloads
module's `cis-oke/MIGRATION.md`. Upstream ignores pool-level freeform tag updates;
this adapter does not patch downloaded modules or bypass that validation.
Do not commit state, saved plans, kubeconfigs, credentials or raw tenancy evidence.
