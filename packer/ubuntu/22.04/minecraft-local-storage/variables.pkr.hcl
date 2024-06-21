variable "proxmox_node" {
  type    = string
}
variable "source_image_name" {
  type = string
}
variable "image_storage_pool" {
  type = string    
}
variable "destination_image_name" {
  type = string
}
variable "admin_password" {
  type = string
}
variable "file_server" {
  type = string
}
variable "share_name" {
  type = string
}
variable "share_path" {
  type = string
}
variable "share_username" {
  type = string
}
variable "share_password" {
  type = string
}
variable "minecraft_server_name" {
  type = string
}
variable "minecraft_game_mode" {
  type = string
}
variable "minecraft_difficulty" {
  type = string
}
variable "minecraft_allow_cheats" {
  type = bool
}
variable "minecraft_max_players" {
  type = number
}
variable minecraft_allow_list {
  type = bool
}
variable "minecraft_level_name" {
  type = string
}
variable "minecraft_level_seed" {
  type = string
}
variable minecraft_detault_permission_level {
  type = string
}
variable "minecraft_operator" {
  type = string
}