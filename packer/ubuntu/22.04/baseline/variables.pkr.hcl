variable "proxmox_node" {
  type    = string
}
variable "image_name" {
  type = string
}
variable "image_version" {
  type = string
}
variable "image_description" {
  type    = string
  default = ""
}
variable "image_storage_pool" {
  type = string    
}
variable "iso_file" {
  type = string
}
variable "iso_storage_pool" {
  type = string
}