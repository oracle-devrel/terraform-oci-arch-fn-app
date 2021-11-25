## Copyright (c) 2021 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ocir_user_name" {}
variable "ocir_user_password" {}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "oci-arch-fn-app" {
  source             = "github.com/oracle-devrel/terraform-oci-arch-fn-app"
  tenancy_ocid       = var.tenancy_ocid
  user_ocid          = var.user_ocid
  fingerprint        = var.fingerprint
  region             = var.region
  private_key_path   = var.private_key_path
  compartment_ocid   = var.compartment_ocid
  ocir_user_name     = var.ocir_user_name
  ocir_user_password = var.ocir_user_password
  use_existing_vcn   = true
  vcn_id             = oci_core_virtual_network.my_vcn.id
  fn_subnet_id       = oci_core_subnet.my_public_subnet.id
}

output "buckets_created" {
  value = module.oci-arch-fn-app.buckets_created
}

