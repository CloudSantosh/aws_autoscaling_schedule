variable "keypair-algorithm" {
  type        = string
  default     = "RSA"
  description = "Algorithm used for generation of keypair"
}

variable "keypair-name" {
  type        = string
  default     = "project-keypair"
  description = "Name of keypair"
}

variable "rsa-bit" {
  type        = number
  default     = 4096
  description = "RSA bit used"
}
