source "proxmox-clone" "ubuntu" {

  clone_vm                 = var.source_image_name
  node                     = var.proxmox_node
  memory                   = 4096
  cores                    = 2
  sockets                  = 2
  ssh_timeout              = "60m"
  ssh_username             = "ubuntu"
  ssh_password             = var.admin_password
  ssh_port                 = 22
  insecure_skip_tls_verify = true
  vm_name                  = var.destination_image_name

}