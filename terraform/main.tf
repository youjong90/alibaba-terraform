provider "alicloud" {
    region = "cn-hangzhou"
}

resource "alicloud_security_group" "harry_ecs_sg" {
    name = "harry-ecs-sg"
    vpc_id = alicloud_vpc.harry_vpc.id
    description = "harry sg for ecs"
}

resource "alicloud_security_group_rule" "harry_ecs_sg_ingress_rule" {
    type = "ingress"
    ip_protocol = "tcp"
    nic_type = "intranet"
    policy = "accept"
    port_range = "22/23"
    priority = 1
    security_group_id = alicloud_security_group.harry_ecs_sg.id
    cidr_ip = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "harry_ecs_sg_egress_rule" {
    type = "egress"
    ip_protocol = "tcp"
    nic_type = "intranet"
    policy = "accept"
    port_range = "1/65535"
    priority = 1
    security_group_id = alicloud_security_group.harry_ecs_sg.id
    cidr_ip = "0.0.0.0/0"
}

resource "alicloud_instance" "harry_ecs2" {
    availability_zone = data.alicloud_zones.harry.zones.0.id
    security_groups = alicloud_security_group.harry_ecs_sg.*.id

    instance_name = "harry-ecs2"
    instance_type = "ecs.n1.tiny"
    #instance_charge_type = "PostPaid"
    password = "Mz1998!!"
    #system_disk_category = "cloud_efficiency"
    system_disk_name = "harry-terraform-disk"
    system_disk_description = "harry ecs disk"
    image_id = "aliyun_3_x64_20G_qboot_alibase_20230214.vhd"
    vswitch_id = alicloud_vswitch.harry_vswitch.id
    data_disks {
        name = "disk2"
        size = 20
        category = "cloud_efficiency"
        description = "disk2"
        encrypted = false
    }
}

resource "alicloud_eip_association" "name" {
    allocation_id = alicloud_eip.harry_eip.id
    instance_id = alicloud_instance.harry_ecs2.id
}
