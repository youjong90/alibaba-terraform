resource "alicloud_vpc" "harry_vpc" {
    vpc_name = "harry-terraform-vpc"
    cidr_block = "84.21.0.0/16"
    description = "harry test"
}

data "alicloud_zones" "harry" {
    available_resource_creation = "VSwitch"
}

data "alicloud_enhanced_nat_available_zones" "enhanced" {
}

resource "alicloud_vswitch" "harry_vswitch" {
    vswitch_name = "harry-terraform-vswitch"
    cidr_block = "84.21.0.0/24"
    vpc_id = alicloud_vpc.harry_vpc.id
    zone_id = data.alicloud_zones.harry.zones.0.id
/*     tags = {
        BuiltBy = "harry"
        Environment = "prd"
    } */
}

resource "alicloud_vswitch" "harry_vswitch_nat" {
    vswitch_name = "harry-terraform-vswitch-nat"
    zone_id = data.alicloud_enhanced_nat_available_zones.enhanced.zones.0.zone_id
    cidr_block = "84.21.1.0/24"
    vpc_id = alicloud_vpc.harry_vpc.id
}

resource "alicloud_nat_gateway" "enhanced" {
    depends_on = [ alicloud_vswitch.harry_vswitch_nat ]
    vpc_id = alicloud_vpc.harry_vpc.id
    nat_gateway_name = "harry-terraform-nat"
    payment_type = "PayAsYouGo"
    vswitch_id = alicloud_vswitch.harry_vswitch_nat.id
    nat_type = "Enhanced"
}

resource "alicloud_vswitch" "harry_vswitch_k8s_nodes" {
    vswitch_name = "harry-vswitch-k8s-nodes"
    zone_id = data.alicloud_zones.harry.zones.0.id
    cidr_block = "84.21.2.0/24"
    vpc_id = alicloud_vpc.harry_vpc.id
}

resource "alicloud_vswitch" "harry_vswitch_k8s_pods" {
    vswitch_name = "harry-vswitch-k8s-pods"
    zone_id = data.alicloud_zones.harry.zones.0.id
    cidr_block = "84.21.3.0/24"
    vpc_id = alicloud_vpc.harry_vpc.id
}

resource "alicloud_eip" "harry_eip" {
    bandwidth = "10"
    internet_charge_type = "PayByBandwidth"
}

output "harry_eip" {
    value = alicloud_eip.harry_eip.ip_address
}
