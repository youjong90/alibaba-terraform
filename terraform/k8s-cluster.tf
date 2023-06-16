resource "alicloud_cs_managed_kubernetes" "harry_cs_managed_kubernetes" {
    #count = 1
    name = "harry-cs-managed-kubernetes"
    cluster_spec = "ack.standard"
    #version = ""
    worker_vswitch_ids = [alicloud_vswitch.harry_vswitch_k8s_nodes.id]  # Define vswitches used by control plane
    #node_cidr_mask
    #proxy_mode 
    service_cidr = "192.168.1.0/24"
    #pod_cidr = "192.168.0.0/24" For flannel in which each pod gets eni
    pod_vswitch_ids = [alicloud_vswitch.harry_vswitch_k8s_pods.id]
    #slb_internet_enabled = true

/*     enable_ssh = true  Will be deprecated
    password = "Mz1998!!"
    runtime = {
      name = "containerd"
      version = "1.5.10"
    } */

    dynamic "addons" {
      for_each = var.cluster_addons
      content {
        name = lookup(addons.value, "name", var.cluster_addons)
        config = lookup(addons.value, "config", var.cluster_addons)
        #disabled = lookup(addons.value, "disabled", var.cluster_addons)
      }
    }
}


resource "alicloud_ram_policy" "harry_ram_policy" {
  policy_name     = "harry-ram-policy"
  policy_document = <<EOF
  {
    "Statement": [
      {
        "Action": [
          "cs:Get*",
          "cs:List*",
          "cs:Describe*"
        ],
        "Effect": "Allow",
        "Resource": [
          "acs:cs:*:*:cluster/${alicloud_cs_managed_kubernetes.harry_cs_managed_kubernetes.id}"
        ]
      }
    ],
    "Version": "1"
  }
  EOF
  description     = "this is a policy test by tf"
  force           = true
}

resource "alicloud_ram_user_policy_attachment" "attach" {
    policy_name = alicloud_ram_policy.harry_ram_policy.name
    policy_type = alicloud_ram_policy.harry_ram_policy.type
    user_name = "sjhwang"
}

resource "alicloud_cs_kubernetes_permissions" "harry_cs_kubernetes_permissions" {
    uid = "253360486550438397"

    permissions {
      cluster = alicloud_cs_managed_kubernetes.harry_cs_managed_kubernetes.id
      role_type = "cluster"
      role_name = "admin"
      namespace = ""
      is_custom = false
      is_ram_role = false
    }

    depends_on = [ 
      alicloud_ram_user_policy_attachment.attach
     ]
}
