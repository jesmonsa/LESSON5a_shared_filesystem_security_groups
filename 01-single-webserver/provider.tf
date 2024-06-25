terraform { # Versión de Terraform.
  required_providers { # Proveedores requeridos.
    oci = {
      source = "oracle/oci" # Fuente del proveedor de OCI.
      version = "5.35.0" # Versión del proveedor de OCI.
    }
  }
}

# General Provider 
provider "oci" { # Proveedor de OCI.
  tenancy_ocid     = var.tenancy_ocid # ID del tenancy.
  user_ocid        = var.user_ocid # ID del usuario.
  fingerprint      = var.fingerprint # Huella digital de la clave pública.
  private_key_path = var.private_key_path # Ruta de la clave privada.
  region           = var.region # Región de OCI.
}

# Home Region Provider
provider "oci" {
  alias                = "homeregion" # Alias del proveedor.
  tenancy_ocid         = var.tenancy_ocid # ID del tenancy.
  user_ocid            = var.user_ocid # ID del usuario.
  fingerprint          = var.fingerprint # Huella digital de la clave pública.
  private_key_path     = var.private_key_path # Ruta de la clave privada.
  region               = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name
  disable_auto_retries = "true"
}
