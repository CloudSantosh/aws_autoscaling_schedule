#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Create a key with RSA algorithm with 4096 rsa bits
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "tls_private_key" "private_key" {
  algorithm = var.keypair-algorithm
  rsa_bits  = var.rsa-bit
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#create a key pair using above private key
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "aws_key_pair" "keypair" {
  key_name   = var.keypair-name
  public_key = tls_private_key.private_key.public_key_openssh
  depends_on = [tls_private_key.private_key]
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# saving the private key at the specific location
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resource "local_file" "save-key" {
  content = tls_private_key.private_key.private_key_pem
  //path.module is the module that access current working directory

  filename = "${path.module}/${var.keypair-name}.pem"
  # changes the file permission to read-only mode
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/${var.keypair-name}.pem"

  }
}
