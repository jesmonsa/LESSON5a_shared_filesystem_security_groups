# It generates Key Pair for WebServer Instnance
resource "tls_private_key" "public_private_key_pair" { # Par de claves
  algorithm = "RSA" # Algoritmo
}
