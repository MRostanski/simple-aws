resource "aws_security_group_rule" "allow_ingress_eks" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]

  security_group_id = module.security_groups["eks-additional"].id
}

resource "aws_security_group_rule" "allow_egress_additional" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = module.security_groups["eks-additional"].id
}

resource "aws_security_group_rule" "allow_ingress_remote" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]

  security_group_id = module.security_groups["remote-access"].id
}

resource "aws_security_group_rule" "allow_egress_remote" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = module.security_groups["remote-access"].id
}

resource "aws_security_group_rule" "allow_ingress_db" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.security_groups["eks-additional"].id

  security_group_id = module.security_groups["db"].id
}

resource "aws_security_group_rule" "allow_egress_db" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = module.security_groups["db"].id
}

resource "aws_security_group_rule" "allow_ingress_cache" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.security_groups["eks-additional"].id

  security_group_id = module.security_groups["cache"].id
}

resource "aws_security_group_rule" "allow_egress_cache" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = module.security_groups["cache"].id
}