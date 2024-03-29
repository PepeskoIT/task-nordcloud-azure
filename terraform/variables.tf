variable "control_host_pub_ip" {
}

##
variable app_name {
    description = "Application name"
}

variable location {
    description = "The location in which the resources are deployed such as east US, west Europe"
}

variable "replication_location" {
}


variable environment {
    description = "The environment in which the resources are deployed such as dev, qa, prod"
}

### databases
variable mysql_admin_username {
    description = "Admin username for mysql database"
}

variable mysql_admin_password {
    description = "Admin password for mysql database"
}

variable mysql_server_sku_name {
    description = "MySQL server SKU name"
}

variable mysql_server_storage_size {
    type = number
    description = "MySQL server max allowed storage in GB"
}

variable mysql_server_geo_redundand {
    type = bool
    description = "Turn Geo-redundant server backups on/off"
}

variable mysql_server_iops_size {
    type = number
}

variable mysql_server_auto_grow_enabled {
    type = bool
}

variable mysql_server_high_availability {
    type = map
    default = {}
}

variable mysql_server_backup_retention_days {
    type = number
    default = null
}

variable mysql_server_maintenance_window {
    type = map
    default = {}
}

variable service_plan_sku_name {
    description = "Azure service SKU plan name"
}

variable web_app_always_on {
    type = bool
}

### acr
variable container_registry_sku_name {
}

## storage
variable "storage_accout_replication_type" {
}