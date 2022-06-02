variable "vpc_id" {
  type        = string
  description = "VPC the SG belongs to"
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "name" {
  type        = string
  description = "envrionment name"
}

variable "purpose" {
  type        = string
  description = "SG purpose"
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-${var.purpose}"
  description = var.purpose
  vpc_id      = var.vpc_id

  tags = var.tags
}

output "id" {
  value = aws_security_group.this.id
}