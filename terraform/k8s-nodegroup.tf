resource "alicloud_cs_kubernetes_node_pool" "harry_cs_kubernetes_node_pool" {  # Node Pool automatically creates Autoscaling Group.
    name = "harry-node-pool"
    cluster_id = alicloud_cs_managed_kubernetes.harry_cs_managed_kubernetes.id
    vswitch_ids = [alicloud_vswitch.harry_vswitch_k8s_nodes.id]
    instance_types = ["ecs.sn1ne.xlarge"]

    system_disk_category = "cloud_efficiency"
    system_disk_size = 20
    password = "Mz1998!!"

    #desired_size = 1  if autoscaling is enabled, cannot use this option.
    
    scaling_config {
      min_size = 1
      max_size = 2
    }
}

resource "alicloud_cs_autoscaling_config" "harry_cs_autoscaling_config" {
    cluster_id = alicloud_cs_managed_kubernetes.harry_cs_managed_kubernetes.id

    cool_down_duration = "10m"
    unneeded_duration = "10m"
    utilization_threshold = "0.5"
    scan_interval = "30s"
    scale_down_enabled = true
    expander = "least-waste"  
}

/* resource "alicloud_ess_scaling_group" "harry_ess_scaling_group" {
    scaling_group_name = "harry-scaling-group"

    min_size = 1
    max_size = 2
    vswitch_ids = [alicloud_vswitch.harry_vswitch.id]
    # removal_policies = 
}

resource "alicloud_ess_scaling_configuration" "harry_ess_scaling_configuration" {
    image_id = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
    security_group_id = alicloud_security_group.harry_ecs_sg.id
    scaling_group_id = alicloud_ess_scaling_group.harry_ess_scaling_group.id
    instance_type = "ecs.c8y.large"
    internet_charge_type = "PayByTraffic"
    force_delete = true
    enable = true
    active = true
}

resource "alicloud_cs_kubernetes_autoscaler" "harry_cs_kubernetes_autoscaler" {
    cluster_id = alicloud_cs_managed_kubernetes.harry_cs_managed_kubernetes.id
    
    nodepools {
      id = alicloud_ess_scaling_group.harry_ess_scaling_group.id
      labels = "a=b"
    }

    #utilization = 
    cool_down_duration = 10
    # defer_scale_in_duration 

    depends_on = [ alicloud_ess_scaling_group.harry_ess_scaling_group, alicloud_ess_scaling_configuration.harry_ess_scaling_configuration ]
} */
