## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_functions_application" "test_application" {
    compartment_id = var.compartment_ocid
    display_name = "cloud-events-demo"
    subnet_ids = [!var.use_existing_vcn ? oci_core_subnet.fnsubnet[0].id : var.fn_subnet_id]
    defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_functions_function" "test_function" {
    depends_on = [null_resource.test_function_Push2OCIR]
    application_id = oci_functions_application.test_application.id
    display_name = "cloud-events-demo-fn"
    image = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/cloud-events-demo-fn:0.0.1"
    memory_in_mbs = "256" 
    config = { 
      "REGION" : "${var.region}"
    }
    defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

