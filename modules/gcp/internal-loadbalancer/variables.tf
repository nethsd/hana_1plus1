variable "location" {}

variable "tags" {
  type    = "map"
  default = {}
}

variable "name" {}

variable "zones" {
  type    = "list"
  default = [1]
}

variable "zone_aware" {
  default = "false"
}

variable "subnet_id" {}
variable "resource_group_name" {}
variable "private_ip_address" {}
variable "floating_ip_enable" {
default = false
}
variable "is_tcp_port22_probe" {
  default = true
}

variable "load_distribution" {
  default = ""
}

variable "name_of_lb_probe" {
  default = "tcp-22"
}

variable "port_of_lb_probe" {
  type = "list"

  default = [
    "22",
  ]
}

variable "protocol_of_lb_probe" {
  default = "Tcp"
}

variable "lb_enabled" {
  default = "true"
}

variable "interval_of_lb_probe" {
  default = "5"
}

variable "number_of_lb_probes" {
  description = "The number of failed probe attempts after which the backend endpoint is removed from rotation."
  default     = "2"
}

variable "request_path_of_lb_probe" {
  description = "The URI used for requesting health status from the backend endpoint."
  default     = ""
}

variable "protocol_of_lb" {
  default = "All"
}

variable "frontend_port_of_lb" {
  type = "list"

  default = [
    "80",
  ]
}

variable "backend_port_of_lb" {
  type = "list"

  default = [
    "8080",
  ]
}

variable "idle_timeout_mins_of_lb" {
  default = "4"
}

