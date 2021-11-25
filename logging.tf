## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_logging_log_group" "log_group" {
    compartment_id = var.compartment_ocid
    display_name = "log_group"
}

resource "oci_logging_log" "log_on_fn_invoke" {
    display_name = "log_on_fn_invoke"
    log_group_id = oci_logging_log_group.log_group.id
    log_type     = "SERVICE"

    configuration {
        source {
            category = "invoke"
            resource = oci_functions_application.test_application.id
            service = "functions"
            source_type = "OCISERVICE"
        }
        compartment_id = var.compartment_ocid
    }
    is_enabled = true
}

resource "oci_logging_log" "log_on_event_trigger" {
    display_name = "log_on_event_trigger"
    log_group_id = oci_logging_log_group.log_group.id
    log_type     = "SERVICE"

    configuration {
        source {
            category = "ruleexecutionlog"
            resource = oci_events_rule.cloud-events-test.id
            service = "cloudevents"
            source_type = "OCISERVICE"
        }
        compartment_id = var.compartment_ocid
    }
    is_enabled = true
}
