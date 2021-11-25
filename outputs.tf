## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "buckets_created" {
 value = "${oci_objectstorage_bucket.bucket.name}, ${oci_objectstorage_bucket.function-output-bucket.name}"
}