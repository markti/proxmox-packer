build {
  sources = [
    "source.proxmox-iso.ubuntu"
  ]

  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done", "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg", "sudo cloud-init clean", "sudo passwd -d ubuntu"]
  }

}