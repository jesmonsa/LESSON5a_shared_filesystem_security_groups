# Home Region Subscription DataSource
data "oci_identity_region_subscriptions" "home_region_subscriptions" { # Suscripciones de la región de inicio
  tenancy_id = var.tenancy_ocid # ID del tenancy

  filter { # Filtro
    name   = "is_home_region" # Es la región de inicio
    values = [true] # Verdadero
  }
}

# ADs DataSource
data "oci_identity_availability_domains" "ADs" { # Dominios de disponibilidad
  compartment_id = var.tenancy_ocid # ID del tenancy
}

# Images DataSource
data "oci_core_images" "OSImage" { # Imágenes
  compartment_id           = var.compartment_ocid # ID del compartment
  operating_system         = var.instance_os # Sistema operativo
  operating_system_version = var.linux_os_version # Versión del sistema operativo
  shape                    = var.Shape # Forma

  filter { # Filtro
    name   = "display_name" # Nombre de visualización
    values = ["^.*Oracle[^G]*$"] # Expresión regular
    regex  = true # Expresión regular
  }
}

# Compute VNIC Attachment DataSource (VNIC Attachment)
data "oci_core_vnic_attachments" "Webserver1_VNIC1_attach" { # Adjunto de VNIC
  availability_domain = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name # Selecciona el primer AD si no se especifica uno
  compartment_id      = oci_identity_compartment.prod_01.id # ID del compartment
  instance_id         = oci_core_instance.Webserver1.id # ID de la instancia
}

# Compute VNIC DataSource
data "oci_core_vnic" "Webserver1_VNIC1" { # VNIC
  vnic_id = data.oci_core_vnic_attachments.Webserver1_VNIC1_attach.vnic_attachments.0.vnic_id # ID de la VNIC
}
