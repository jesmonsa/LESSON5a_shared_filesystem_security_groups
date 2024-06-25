# WebServer Compute

resource "oci_core_instance" "Webserver1" { # Webserver1 es el nombre del recurso
  availability_domain = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name # Selecciona el primer AD si no se especifica uno
  compartment_id      = oci_identity_compartment.prod_01.id # ID del compartment
  display_name        = "WebServer" # Nombre del servidor
  shape               = var.Shape # Forma de la instancia

  dynamic "shape_config" { # Configuración de la forma
    for_each = local.is_flexible_shape ? [1] : [] # Si es una forma flexible
    content { # Contenido
      memory_in_gbs = var.FlexShapeMemory # Memoria en GB
      ocpus         = var.FlexShapeOCPUS # CPUs
    }
  }

  source_details { # Detalles de la fuente
    source_type = "image" # Tipo de fuente
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id") # ID de la imagen
  }

  metadata = { # Metadatos
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh # Clave pública SSH
  }

  create_vnic_details { # Detalles de la creación de la VNIC
    subnet_id        = oci_core_subnet.WebSubnet.id # ID de la subred
    assign_public_ip = true # Asignar IP pública
  }
}

