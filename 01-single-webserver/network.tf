# VCN
resource "oci_core_virtual_network" "Prod_VCN" { # VCN
  cidr_block     = var.VCN-CIDR # CIDR
  dns_label      = "Prod_VCN" # Etiqueta DNS
  compartment_id = oci_identity_compartment.prod_01.id # ID del compartment
  display_name   = "Prod_VCN"
}

# DHCP Options
resource "oci_core_dhcp_options" "DhcpOptions1" { # Opciones DHCP
  compartment_id = oci_identity_compartment.prod_01.id # ID del compartment
  vcn_id         = oci_core_virtual_network.Prod_VCN.id # ID de la VCN
  display_name   = "DHCPOptions1" # Nombre de visualización

  options {
    type        = "DomainNameServer" # Tipo
    server_type = "VcnLocalPlusInternet" # Tipo de servidor
  }

  options {
    type                = "SearchDomain" # Tipo
    search_domain_names = ["example.com"] # Dominio de búsqueda
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "InternetGateway" {
  compartment_id = oci_identity_compartment.prod_01.id # ID del compartment
  display_name   = "InternetGateway"
  vcn_id         = oci_core_virtual_network.Prod_VCN.id # ID de la VCN
}

# Route Table
resource "oci_core_route_table" "RouteTableViaIGW" {
  compartment_id = oci_identity_compartment.prod_01.id # ID del compartment
  vcn_id         = oci_core_virtual_network.Prod_VCN.id # ID de la VCN
  display_name   = "RouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.InternetGateway.id
  }
}

# Security List
resource "oci_core_security_list" "SecurityList" { # Lista de seguridad
  compartment_id = oci_identity_compartment.prod_01.id # ID del compartment
  display_name   = "SecurityList" # Nombre de visualización
  vcn_id         = oci_core_virtual_network.Prod_VCN.id # ID de la VCN

  egress_security_rules { # Reglas de seguridad de salida
    protocol    = "6" # Protocolo
    destination = "0.0.0.0/0" # Destino
  }

  dynamic "ingress_security_rules" { # Reglas de seguridad de entrada
    for_each = var.service_ports # Puertos de servicio
    content { # Contenido 
      protocol = "6" # Protocolo
      source   = "0.0.0.0/0" # Origen
      tcp_options {
        max = ingress_security_rules.value # Máximo
        min = ingress_security_rules.value # Mínimo
      }
    }
  }

  ingress_security_rules { # Reglas de seguridad de entrada
    protocol = "6" # Protocolo
    source   = var.VCN-CIDR # Origen
  }
}

# Subnet
resource "oci_core_subnet" "WebSubnet" { # Subred
  cidr_block        = var.Subnet-CIDR # CIDR
  display_name      = "WebSubnet" # Nombre de visualización
  dns_label         = "WebSubnet" # Etiqueta DNS
  compartment_id    = oci_identity_compartment.prod_01.id # ID del compartment
  vcn_id            = oci_core_virtual_network.Prod_VCN.id # ID de la VCN
  route_table_id    = oci_core_route_table.RouteTableViaIGW.id # ID de la tabla de rutas
  dhcp_options_id   = oci_core_dhcp_options.DhcpOptions1.id # ID de las opciones DHCP
  security_list_ids = [oci_core_security_list.SecurityList.id] # ID de la lista de seguridad
}
