provider "alicloud" {
  configuration_source = "terraform-provider-alicloud/examples/vpc"
}

resource "alicloud_vpc" "main" {
  vpc_name       = var.long_name
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "main" {
  depends_on = [alicloud_vpc.main]
  vpc_id            = alicloud_vpc.main.id
  count             = length(var.cidr_blocks)
  cidr_block        = var.cidr_blocks["az${count.index}"]
  zone_id = var.availability_zones
}

resource "alicloud_nat_gateway" "main" {
  depends_on = [alicloud_vpc.main, alicloud_vswitch.main]
  vpc_id     = alicloud_vpc.main.id
  vswitch_id = alicloud_vswitch.main[0].id
  nat_gateway_name = "from-tf-example"
  nat_type = "Enhanced"
  payment_type = "PayAsYouGo"

}

resource "alicloud_eip" "foo" {
  payment_type = "PayAsYouGo"
  internet_charge_type = "PayByTraffic"
  bandwidth = "200"
}

resource "alicloud_eip_association" "foo" {
  allocation_id = alicloud_eip.foo.id
  instance_id   = alicloud_nat_gateway.main.id
}
