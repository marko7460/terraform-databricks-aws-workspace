// EXPLANATION: Create the customer managed-vpc and security group rules
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "${var.workspace_name}-data-plane-VPC"
  cidr = var.vpc_cidr_range
  azs  = var.availability_zones

  enable_dns_hostnames   = true
  enable_nat_gateway     = var.harden_firewall
  single_nat_gateway     = false
  one_nat_gateway_per_az = var.harden_firewall
  create_igw             = var.harden_firewall

  public_subnet_names = var.harden_firewall ? [] : [for az in var.availability_zones : format("%s-public-%s", var.workspace_name, az)]
  public_subnets      = var.harden_firewall ? [] : var.public_subnets_cidr

  private_subnet_names = [for az in var.availability_zones : format("%s-private-%s", var.workspace_name, az)]
  private_subnets      = var.private_subnets_cidr

  intra_subnet_names = [for az in var.availability_zones : format("%s-privatelink-%s", var.workspace_name, az)]
  intra_subnets      = var.privatelink_subnets_cidr

}

// SG
resource "aws_security_group" "sg" {
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]

  dynamic "ingress" {
    for_each = var.sg_ingress_protocol
    content {
      from_port = 0
      to_port   = 65535
      protocol  = ingress.value
      self      = true
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_protocol
    content {
      from_port = 0
      to_port   = 65535
      protocol  = egress.value
      self      = true
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "${var.workspace_name}-data-plane-sg"
  }
}

module "harden_firewall" {
  count  = var.harden_firewall ? 1 : 0
  source = "./data_plane_hardening/firewall"
  providers = {
    aws = aws
  }

  vpc_id                      = module.vpc.vpc_id
  vpc_cidr_range              = var.vpc_cidr_range
  public_subnets_cidr         = var.public_subnets_cidr
  private_subnets_cidr        = module.vpc.private_subnets_cidr_blocks
  private_subnet_rt           = module.vpc.private_route_table_ids
  firewall_subnets_cidr       = var.firewall_subnets_cidr
  firewall_allow_list         = var.firewall_allow_list
  firewall_protocol_deny_list = split(",", var.firewall_protocol_deny_list)
  availability_zones          = var.availability_zones
  region                      = var.region
  resource_prefix             = var.workspace_name

  depends_on = [databricks_mws_workspaces.this, databricks_mws_workspaces.this]
}