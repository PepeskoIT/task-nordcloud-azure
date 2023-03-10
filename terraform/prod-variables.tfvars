environment = "prod"
replication_location = "West Europe"
# database
mysql_admin_username = "admin_prod"
mysql_admin_password = "WlDl672lwKwCicvplq79aTAjKcBmO2ck"
# mysql_server_sku_name = "GP_Gen4_2"
mysql_server_sku_name = "GP_Standard_D2ds_v4"
mysql_server_storage_size = 20
mysql_server_iops_size = 360
mysql_server_auto_grow_enabled = true
mysql_server_geo_redundand = true
mysql_server_high_availability = {
    mode = "SameZone"
    standby_availability_zone = 2
}
mysql_server_backup_retention_days = 7
mysql_server_maintenance_window = {
    day_of_week  = 0
    start_hour   = 8
    start_minute = 0
}
# app
# container_app_custom_domain_hostname = "www.example.com"
service_plan_sku_name = "S1"
# ghost_container_image = ""
web_app_always_on = true
# acr
container_registry_sku_name = "Premium" # allows georedundancy
# storage
storage_accout_replication_type = "GRS" 