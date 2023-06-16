data "alicloud_instance_types" "harry_instance_types" {
    availability_zone = data.alicloud_zones.harry.zones.0.id
    cpu_core_count = 2
    memory_size = 4
    kubernetes_node_role = "Worker"  
}
