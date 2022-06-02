variable "public_key" {
  type    = string
  default = null
}

variable "rsa_bits" {
  type        = number
  default     = 4096
  description = "RSA bits (key complexity)"
}

variable "name" {
  type        = string
  description = "Key name"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_key_pair" "this" {
  key_name_prefix = var.name
  public_key      = var.public_key == null ? tls_private_key.this.public_key_openssh : var.public_key

  tags = var.tags
}

output "name" {
  value = aws_key_pair.this.key_name
}

output "public_key" {
  value = aws_key_pair.this.public_key
}

output "private_key" {
  value = var.public_key == null ? nonsensitive(tls_private_key.this.private_key_openssh) : "not_computed"
}