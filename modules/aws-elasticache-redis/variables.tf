variable "name" {
  type = string
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "node_type" {
  type    = string
  default = "cache.t3.small"
}

variable "nodes_num" {
  type    = number
  default = 3
}

variable "parameters" {
  type    = map(any)
  default = {}
}

variable "port" {
  type    = number
  default = 6379
}

variable "maintenance_window" {
  type    = string
  default = "tue:06:30-tue:07:30"
}

variable "subnet_ids" {
  type = list(any)
}

variable "security_group_ids" {
  type = list(any)
}

variable "engine_family" {
  type    = string
  default = "5.0"
}

variable "engine_version" {
  type    = string
  default = "5.0.6"
}