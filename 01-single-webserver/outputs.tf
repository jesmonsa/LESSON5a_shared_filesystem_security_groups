# WebServer Instance Public IP
output "Webserver1PublicIP" {
  value = [data.oci_core_vnic.Webserver1_VNIC1.vnic.public_ip]
}

# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}
