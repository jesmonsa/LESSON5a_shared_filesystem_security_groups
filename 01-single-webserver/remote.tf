# Software installation within WebServer Instance
resource "null_resource" "Webserver1HTTPD" { # Recurso nulo
  depends_on = [oci_core_instance.Webserver1] # Dependencias
  provisioner "remote-exec" { # Ejecución remota
    connection {
      type        = "ssh" # Tipo de conexión
      user        = "opc" # Usuario
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address # IP pública
      private_key = tls_private_key.public_private_key_pair.private_key_pem # Clave privada
      script_path = "/home/opc/myssh.sh" # Ruta del script
      agent       = false # Agente
      timeout     = "10m" # Tiempo de espera
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'", # Instalando paquete HTTPD con yum
      "sudo -u root yum -y -q install httpd", # Instalando HTTPD

      "echo '== 2. Creating /var/www/html/index.html'", # Creando /var/www/html/index.html
      "sudo -u root touch /var/www/html/index.html", # Creando archivo
      "sudo /bin/su -c \"echo 'Welcome to Example.com! This is WEBSERVER1...' > /var/www/html/index.html\"", # Escribiendo en el archivo

      "echo '== 3. Disabling firewall and starting HTTPD service'", # Deshabilitando el firewall y arrancando el servicio HTTPD
      "sudo -u root service firewalld stop", # Deteniendo el firewall
    "sudo -u root service httpd start"] # Arrancando HTTPD
  }
}
