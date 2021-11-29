resource "oci_sch_service_connector" "cloud_events_service_connector" {
  
    compartment_id = var.compartment_ocid
    display_name = "cloud-events-service-connector"

    source {
        kind = "logging"
        log_sources {
            compartment_id = var.compartment_ocid
            log_group_id = oci_logging_log_group.log_group.id
            log_id = oci_logging_log.log_on_fn_invoke.id
        }
    }

    target {
        kind = "objectStorage"
        bucket = oci_objectstorage_bucket.function-output-bucket.name
        compartment_id = var.compartment_ocid
    }
}