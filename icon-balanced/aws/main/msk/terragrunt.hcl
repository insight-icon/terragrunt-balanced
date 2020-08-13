terraform {
  source = "github.com/hyprnz/terraform-aws-msk-module.git?ref=${local.vars.versions.k8s-cluster}"
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
  client_subnets = dependency.network.outputs.private_subnets

  security_group_id = dependency.network.outputs.k8s_security_group_id
  security_groups = module.example_no_vpc.default_security_group

  worker_additional_security_group_ids = [dependency.network.outputs.consul_security_group_id, dependency.network.outputs.monitoring_security_group_id]
}
