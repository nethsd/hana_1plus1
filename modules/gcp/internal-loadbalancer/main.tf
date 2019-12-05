resource "azurerm_lb" "load_balancer" {
  count               = "${var.zone_aware || var.lb_enabled == "false" ? 0 : 1}"
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEnd"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.private_ip_address}"
    subnet_id                     = "${var.subnet_id}"
  }

  tags = "${var.tags}"
}

resource "azurerm_lb" "load_balancer_zones" {
  count               = "${var.zone_aware && var.lb_enabled == "true" ? 1 : 0}"
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEnd"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.private_ip_address}"
    subnet_id                     = "${var.subnet_id}"
    zones                         = ["${element(var.zones,count.index % length(var.zones))}"]
  }

  tags = "${var.tags}"

  #zones = "${var.zones}"
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  count               = "${var.zone_aware || var.lb_enabled == "false" ? 0 : 1}"
  name                = "${var.name}-fwout-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "backend_pool_zones" {
  count               = "${var.zone_aware && var.lb_enabled == "true" ? 1 : 0}"
  name                = "${var.name}-fwout-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer_zones.id}"
}

# Loadbalancer HA Rule
resource "azurerm_lb_rule" "load_balancer_rule_ha" {
  count               = "${var.zone_aware || var.lb_enabled == "false" ? 0 : length(var.frontend_port_of_lb)}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"

  name                    = "${var.name}-${var.backend_port_of_lb[count.index]}-ha-rule"
  protocol                = "${var.protocol_of_lb}"
  frontend_port           = "${var.frontend_port_of_lb[count.index]}"
  backend_port            = "${var.backend_port_of_lb[count.index]}"
  idle_timeout_in_minutes = "${element(split(",","${var.idle_timeout_mins_of_lb}"),count.index)}"
  load_distribution       = "${var.load_distribution}"
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_probe.*.id[count.index]}"
  enable_floating_ip  ="${var.floating_ip_enable}"
}

resource "azurerm_lb_rule" "load_balancer_rule_ha_zones" {
  count               = "${var.zone_aware && var.lb_enabled == "true" ? length(var.frontend_port_of_lb) : 0 }"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer_zones.id}"

  name                    = "${var.name}-${var.backend_port_of_lb[count.index]}-ha-rule"
  protocol                = "${var.protocol_of_lb}"
  frontend_port           = "${var.frontend_port_of_lb[count.index]}"
  backend_port            = "${var.backend_port_of_lb[count.index]}"
  idle_timeout_in_minutes = "${element(split(",","${var.idle_timeout_mins_of_lb}"),count.index)}"
  load_distribution       = "${var.load_distribution}"
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool_zones.id}"
  probe_id                       = "${azurerm_lb_probe.load_balancer_probe_zones.*.id[count.index]}"
  enable_floating_ip  ="${var.floating_ip_enable}"
}

resource "azurerm_lb_probe" "load_balancer_probe" {
  count               = "${var.zone_aware || var.lb_enabled == "false" ? 0 : length(var.port_of_lb_probe)}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  name                = "${var.name}-${var.port_of_lb_probe[count.index]}-probe"
  port                = "${var.port_of_lb_probe[count.index]}"
  protocol            = "${var.protocol_of_lb_probe}"
  interval_in_seconds = "${var.interval_of_lb_probe}"
  number_of_probes    = "${var.number_of_lb_probes}"
  request_path        = "${var.request_path_of_lb_probe}"
}

resource "azurerm_lb_probe" "load_balancer_probe_zones" {
  count               = "${var.zone_aware && var.lb_enabled == "true" ? length(var.port_of_lb_probe) : 0}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer_zones.id}"
  name                = "${var.name}-${var.port_of_lb_probe[count.index]}-probe"
  port                = "${var.port_of_lb_probe[count.index]}"
  protocol            = "${var.protocol_of_lb_probe}"
  interval_in_seconds = "${var.interval_of_lb_probe}"
  number_of_probes    = "${var.number_of_lb_probes}"
  request_path        = "${var.request_path_of_lb_probe}"
}

