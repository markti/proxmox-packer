/*
data "cloudinit_config" "cloud_init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "user-data"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-init.yaml", {
      server_properties_content = file("${path.module}/files/server.properties")
    })
  }
}

resource "local_file" "cloud_init" {
  content  = data.cloudinit_config.cloud_init.rendered
  filename = "cloud_init_generated.yaml"
}
*/

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
  #cicustom    = local_file.cloud_init.filename

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