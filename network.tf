resource "oci_core_vcn" "vcn" {
  compartment_id = var.oci_compartment_id
  cidr_block     = var.oci_vcn_cidr_block
  dns_label      = var.oci_vcn_dns_label
  display_name   = "subnet"
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.oci_compartment_id
  display_name   = "subnet_internet_gw"
  vcn_id         = oci_core_vcn.vcn.id
}

# Public Route Table
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.oci_compartment_id 
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "subnet_public_rt"

  route_rules {
    destination  = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Subnet
resource "oci_core_subnet" "subnet" {
  availability_domain = var.oci_ad
  compartment_id      = var.oci_compartment_id 
  vcn_id              = oci_core_vcn.vcn.id
  cidr_block          = cidrsubnet(var.oci_vcn_cidr_block, 8, 1)
  display_name        = "subnet"
  dns_label           = var.oci_vcn_dns_label
  route_table_id      = oci_core_route_table.public_rt.id
  security_list_ids   = [oci_core_security_list.security_list.id]
}

resource "oci_core_security_list" "security_list" {
  display_name        = "sec_list_public"
  compartment_id      = var.oci_compartment_id 
  vcn_id              = oci_core_vcn.vcn.id

  egress_security_rules {
    protocol          = "all"
    destination       = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol          = "6"
    source            = "0.0.0.0/0" 

    tcp_options {
      min = 22
      max = 22
    }
  }
}
