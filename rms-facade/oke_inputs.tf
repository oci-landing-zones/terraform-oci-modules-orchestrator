module "oke_inputs" {
  source         = "../modules/oke-inputs"
  configurations = local.merged_input_configs
}
