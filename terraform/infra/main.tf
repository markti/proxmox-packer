
resource "proxmox_vm_qemu" "minecraft-2204" {

  target_node = "pve"
  clone       = var.vm_image
  name        = "TestVM"
  agent       = 1
  cores       = 2
  sockets     = 1
  memory      = 8096
  onboot      = false
  bootdisk    = "scsi0"
  scsihw      = "lsi"

  sshkeys = file("~/.ssh/id_rsa.pub")

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.storage_pool
          size    = 128
        }
      }
    }
  }

}