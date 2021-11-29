## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_virtual_network" "vcn" {
  count          = !var.use_existing_vcn ? 1 : 0
  cidr_block     = var.VCN-CIDR
  dns_label      = "vcn"
  compartment_id = var.compartment_ocid
  display_name   = "vcn"
}

resource "oci_core_internet_gateway" "igw" {
    count          = !var.use_existing_vcn ? 1 : 0
    compartment_id = var.compartment_ocid
    display_name   = "igw"
    vcn_id         = oci_core_virtual_network.vcn[0].id
}


resource "oci_core_route_table" "rt_via_igw" {
    count          = !var.use_existing_vcn ? 1 : 0
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn[0].id
    display_name   = "rt_via_igw"
    route_rules {
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.igw[0].id
    }
}

resource "oci_core_dhcp_options" "dhcpoptions1" {
  count          = !var.use_existing_vcn ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn[0].id
  display_name   = "dhcpoptions1"

  // required
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

}

resource "oci_core_subnet" "fnsubnet" {
  count             = !var.use_existing_vcn ? 1 : 0
  cidr_block        = var.fnsubnet-CIDR
  display_name      = "fnsubnet"
  dns_label         = "fnsub"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn[0].id
  route_table_id    = oci_core_route_table.rt_via_igw[0].id
  dhcp_options_id   = oci_core_dhcp_options.dhcpoptions1[0].id
  security_list_ids = [oci_core_virtual_network.vcn[0].default_security_list_id]
}

