terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks.git?ref=${local.vars.versions.k8s-cluster}"
}

include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl")).locals
  network = find_in_parent_folders("network")
}

dependencies {
  paths = [local.network]
}

dependency "network" {
  config_path = local.network
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  subnets = dependency.network.outputs.public_subnets
  security_group_id = dependency.network.outputs.k8s_security_group_id

  worker_additional_security_group_ids = [dependency.network.outputs.consul_security_group_id, dependency.network.outputs.monitoring_security_group_id]
}
