# All variables used by the automation.

variable "tenancy_ocid" {} # ID del tenancy
variable "user_ocid" {} # ID del usuario
variable "fingerprint" {} # Huella digital
variable "private_key_path" {} # Ruta de la clave privada
variable "compartment_ocid" {} # ID del compartment
variable "region" {} # Región
variable "availability_domain_name" { # Nombre del dominio de disponibilidad
  default = ""
}

variable "VCN-CIDR" { # CIDR de la VCN
  default = "10.0.0.0/16" # CIDR de la VCN
}

variable "Subnet-CIDR" { # CIDR de la subred
  default = "10.0.1.0/24" # CIDR de la subred
}

variable "Shape" { # Forma
  default = "VM.Standard.E3.Flex" # Forma
}

variable "FlexShapeOCPUS" { # CPUs de la forma flexible
  default = 1 # CPUs
}

variable "FlexShapeMemory" { # Memoria de la forma flexible
  default = 1 # Memoria
}

variable "instance_os" { # Sistema operativo de la instancia
  default = "Oracle Linux" # Sistema operativo
}

variable "linux_os_version" { # Versión de Oracle Linux
  default = "7.9" # Versión
}

variable "service_ports" { # Puertos de servicio
  default = [80, 443, 22] # Puertos
}

# Dictionary Locals
locals { # Locales
  compute_flexible_shapes = [ # Formas flexibles
    "VM.Standard.E3.Flex", # Forma flexible
    "VM.Standard.E4.Flex", # Forma flexible
    "VM.Standard.A1.Flex", # Forma flexible
    "VM.Optimized3.Flex" # Forma flexible
  ]
}

# Checks if is using Flexible Compute Shapes
locals { # Locales
  is_flexible_shape = contains(local.compute_flexible_shapes, var.Shape) # Forma flexible
}
