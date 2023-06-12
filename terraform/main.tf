terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.206.0"
    }
  }
}

provider "alicloud" {
	access_key = var.alicloud_access_key
	secret_key = var.alicloud_secret_key
}

