variable "os_disk_setting" {
    type = object({
    caching              = string
    storage_account_type = string
    name                 = string
    })
  
}