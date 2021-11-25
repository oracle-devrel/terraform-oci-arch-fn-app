## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_events_rule" "cloud-events-test" {
    actions {
        actions {
            action_type = "FAAS"
            is_enabled  = true
            description = "An event rule to invoke function"
            function_id = oci_functions_function.test_function.id
        }
    }
    compartment_id = var.compartment_ocid
    condition = "{ \"eventType\": \"com.oraclecloud.objectstorage.createobject\", \"data\": {\"additionalDetails\": {\"bucketId\": \"${oci_objectstorage_bucket.bucket.bucket_id}\" } } }"
    display_name = "cloud-events-test"
    is_enabled = true
    defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

