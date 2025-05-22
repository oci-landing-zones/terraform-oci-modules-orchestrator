# Copyright (c) 2024 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

moved {
  from = module.cislz_compartments
  to   = module.oci_lz_compartments[0]
}

moved {
  from = module.cislz_groups
  to   = module.oci_lz_groups[0]
}

moved {
  from = module.cislz_dynamic_groups
  to   = module.oci_lz_dynamic_groups[0]
}

moved {
  from = module.cislz_policies
  to   = module.oci_lz_policies[0]
}

moved {
  from = module.terraform-oci-cis-landing-zone-network
  to   = module.oci_lz_network[0]
}