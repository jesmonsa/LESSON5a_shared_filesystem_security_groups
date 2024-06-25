# WebServer Instance Public IP
output "Webserver1PublicIP" {
  value = oci_core_instance.WebServer1.public_ip
}


# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}
