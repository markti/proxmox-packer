source "proxmox-iso" "ubuntu" {
  
  boot_command = [
    "c", 
    "linux /casper/vmlinuz -- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait><wait>", 
    "initrd /casper/initrd", 
    "<enter><wait><wait>", 
    "boot<enter>"
    ]
  boot_wait    = "10s"

  disks {
    disk_size         = "8G"
    storage_pool      = var.image_storage_pool
    type              = "scsi"
  }
  
  http_directory           = "http"
  insecure_skip_tls_verify = true
  iso_file                 = var.iso_file
  iso_checksum             = "none"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  node                 = var.proxmox_node
  memory               = 4096
  cores                = 2
  sockets              = 2

  ssh_timeout            = "60m"
  ssh_username           = "ubuntu"
  ssh_password           = "ubuntu"
  ssh_port               = 22
  qemu_agent             = true
  template_description   = var.image_description
  template_name          = var.image_name
  unmount_iso            = true

}