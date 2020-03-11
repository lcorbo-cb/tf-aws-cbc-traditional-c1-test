output "ovpn" {
  value = module.vpc.ovpn
}

output "securitygroup" {
  value = module.vpc.securitygroup
}

output "subnets" {
  value = module.vpc.subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

locals {
  ec2_output_keys   = [for key, values in aws_instance.web : key]
  ec2_output_values = [for key, values in aws_instance.web : values["private_ip"]]
  ec2_output_kv     = zipmap(local.ec2_output_keys, local.ec2_output_values)
}

output "ec2_private_ips" {
  value = local.ec2_output_kv
}
