resource "oci_identity_compartment" "Prod_01" {
  provider = oci.homeregion
  name = "CompartmentProd_01"
  description = "Compartment Prod_01"
  compartment_id = var.compartment_ocid
  
  provisioner "local-exec" {
    command = "sleep 60"
  }
}