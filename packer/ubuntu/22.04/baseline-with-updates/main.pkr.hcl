build {
  sources = [
    "source.proxmox-clone.ubuntu"
  ]

  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do echo 'Waiting for other apt-get process to finish...'; sleep 5; done",
      "while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do echo 'Waiting for other dpkg process to finish...'; sleep 5; done",
      "apt-get update",
      "apt-get upgrade -y"
    ]
  }

}