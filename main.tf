module "vpc" {
  source                     = "github.com/lcorbo-cb/tf-aws-vpc-vpn"
  cert                       = var.cert
  key                        = var.key
  ca                         = var.ca
  server_certificate_arn     = var.server_certificate_arn
  root_certificate_chain_arn = var.root_certificate_chain_arn
}

locals {
  manifest = {
    joc = {
      node_type            = "joc"
      iam_instance_profile = ""
    }
    master01 = {
      node_type            = "master"
      iam_instance_profile = aws_iam_instance_profile.s3_plugin_test_ec2.id
    }
    agent01 = {
      node_type            = "agent"
      iam_instance_profile = aws_iam_instance_profile.s3_plugin_test_ec2.id
    }
    master02 = {
      node_type            = "master"
      iam_instance_profile = aws_iam_instance_profile.s3_plugin_test_ec2.id
    }
    agent02 = {
      node_type            = "agent"
      iam_instance_profile = aws_iam_instance_profile.s3_plugin_test_ec2.id
    }
  }
}

resource "aws_instance" "web" {
  for_each                    = local.manifest
  ami                         = var.ami_name
  instance_type               = "t2.medium"
  key_name                    = var.key_name
  subnet_id                   = module.vpc.subnets[0]
  user_data                   = file("${path.module}/startup_scripts/${each.value.node_type}/build.sh")
  iam_instance_profile        = each.value.iam_instance_profile
  vpc_security_group_ids      = [module.vpc.securitygroup]
  associate_public_ip_address = true

  tags = {
    Name = "${var.stack_name}-${each.key}"
  }
}

module "dns" {
  source     = "github.com/lcorbo-cb/tf-aws-r53-private-zone"
  vpc_id     = module.vpc.vpc_id
  record_map = local.ec2_output_kv
  zone_name  = "lcorbo.org"
}
