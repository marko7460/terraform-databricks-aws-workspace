// EXPLANATION: Creates an egress firewall around the dataplane

// Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.resource_prefix}-public-${element(var.availability_zones, count.index)}"
  }
}

// EIP
resource "aws_eip" "ngw_eip" {
  count  = length(var.public_subnets_cidr)
  domain = "vpc"
}

// NGW
resource "aws_nat_gateway" "ngw" {
  count         = length(var.public_subnets_cidr)
  allocation_id = element(aws_eip.ngw_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.resource_prefix}-ngw-${element(var.availability_zones, count.index)}"
  }
}

// Private Subnet Route
resource "aws_route" "private" {
  count                  = length(var.private_subnets_cidr)
  route_table_id         = element(var.private_subnet_rt, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)
}


// Public RT
resource "aws_route_table" "public_rt" {
  count  = length(var.public_subnets_cidr)
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.resource_prefix}-public-rt-${element(var.availability_zones, count.index)}"
  }
}

// Public RT Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public_rt.*.id, count.index)
  depends_on     = [aws_subnet.public]
}

// Firewall Subnet
resource "aws_subnet" "firewall" {
  vpc_id                  = var.vpc_id
  count                   = length(var.firewall_subnets_cidr)
  cidr_block              = element(var.firewall_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.resource_prefix}-firewall-${element(var.availability_zones, count.index)}"
  }
}

// Firewall RT
resource "aws_route_table" "firewall_rt" {
  count  = length(var.firewall_subnets_cidr)
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.resource_prefix}-firewall-rt-${element(var.availability_zones, count.index)}"
  }
}

// Firewall RT Associations
resource "aws_route_table_association" "firewall" {
  count          = length(var.firewall_subnets_cidr)
  subnet_id      = element(aws_subnet.firewall.*.id, count.index)
  route_table_id = element(aws_route_table.firewall_rt.*.id, count.index)
}

// IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.resource_prefix}-igw"
  }
}

// IGW RT
resource "aws_route_table" "igw_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.resource_prefix}-igw-rt"
  }
}

// IGW RT Associations
resource "aws_route_table_association" "igw" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.igw_rt.id
}

// Public Route
resource "aws_route" "public" {
  count                  = length(var.public_subnets_cidr)
  route_table_id         = element(aws_route_table.public_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = tolist(aws_networkfirewall_firewall.nfw.firewall_status[0].sync_states)[count.index].attachment[0].endpoint_id
  depends_on             = [aws_networkfirewall_firewall.nfw]
}

// Firewall Route
resource "aws_route" "firewall_outbound" {
  count                  = length(var.firewall_subnets_cidr)
  route_table_id         = element(aws_route_table.firewall_rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

// Add a route back to FW
resource "aws_route" "firewall_inbound" {
  count                  = length(var.public_subnets_cidr)
  route_table_id         = aws_route_table.igw_rt.id
  destination_cidr_block = element(var.public_subnets_cidr, count.index)
  vpc_endpoint_id        = tolist(aws_networkfirewall_firewall.nfw.firewall_status[0].sync_states)[count.index].attachment[0].endpoint_id
  depends_on             = [aws_networkfirewall_firewall.nfw]
}

// FQDN Allow List
resource "aws_networkfirewall_rule_group" "databricks_fqdn_allowlist" {
  capacity = 100
  name     = "${var.resource_prefix}-${var.region}-databricks-fqdn-allowlist"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = var.firewall_allow_list
      }
    }
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.vpc_cidr_range]
        }
      }
    }
  }
  tags = {
    Name = "${var.resource_prefix}-${var.region}-databricks-fqdn-allowlist"
  }
}

// Protocol Deny LIst
resource "aws_networkfirewall_rule_group" "databricks_protocol_denylist" {
  capacity = 100
  name     = "${var.resource_prefix}-databricks-protocol-denylist"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [var.vpc_cidr_range]
        }
      }
    }
    rules_source {
      dynamic "stateful_rule" {
        for_each = var.firewall_protocol_deny_list
        content {
          action = "DROP"
          header {
            destination      = "ANY"
            destination_port = "ANY"
            protocol         = stateful_rule.value
            direction        = "ANY"
            source_port      = "ANY"
            source           = "ANY"
          }
          rule_option {
            keyword = "sid:${stateful_rule.key + 1}"
          }
        }
      }
    }
  }
  tags = {
    Name = "${var.resource_prefix}-databricks-protocol-denylist"
  }
}


// NFW Policy
resource "aws_networkfirewall_firewall_policy" "databricks_nfw_policy" {
  name = "${var.resource_prefix}-databricks-nfw-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.databricks_fqdn_allowlist.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.databricks_protocol_denylist.arn
    }
  }
  tags = {
    Name = "${var.resource_prefix}-${var.region}-databricks-nfw-policy"
  }
}

// Firewall
resource "aws_networkfirewall_firewall" "nfw" {
  name                = "${var.resource_prefix}-nfw"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.databricks_nfw_policy.arn
  vpc_id              = var.vpc_id
  dynamic "subnet_mapping" {
    for_each = aws_subnet.firewall[*].id
    content {
      subnet_id = subnet_mapping.value
    }
  }
  tags = {
    Name = "${var.resource_prefix}-${var.region}-databricks-nfw"
  }
}