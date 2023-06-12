terraform {
  required_providers {
    alicloud = {
      source = "aliyun/alicloud"
      version = "1.206.0"
    }
  }
}

provider "alicloud" {
	access_key = var.alicloud_access_key != "" ? var.alicloud_access_key : var.env.ALICLOUD_ACCESS_KEY
	secret_key = var.alicloud_secret_key != "" ? var.alicloud_secret_key : var.env.ALICLOUD_SECRET_KEY
	region = "ap-southeast-1"
}
