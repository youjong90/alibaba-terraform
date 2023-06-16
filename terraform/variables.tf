variable "cluster_addons" {
    description = "Addon components in k8s cluster"

    type = list(object({
        name = string
        config = string
    }))

    default = [ {
      "name" = "terway-eniip",
      "config" = "",
    } ]
  
}
