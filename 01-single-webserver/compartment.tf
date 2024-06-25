resource "oci_identity_compartment" "prod_01" { # Nuevo recurso
  provider = oci.homeregion
  name = "Compartment_01" # Nombre del compartimento
  description = "Compartment prod_01" # Descripción del compartimento
  compartment_id = var.compartment_ocid # OCID del compartimento padre

  provisioner "local-exec" { # Provisionador local
    command = "sleep 60" # Espera 60 segundos
  }
}

