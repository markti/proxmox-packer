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

  # We use CURL to grab the server download page from Minecraft.net. With this page, we can scan it and make sure we are grabbing the latest download link.
  # This saves time by ensuring the latest version is always downloaded.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install curl"]
  }

  # The wget package is what we will use to download the Minecraft Bedrock server to Ubuntu.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install wget"]
  }

  # This package is the simplest package we are installing and is what we need to extract the server from the downloaded archive.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update",
      "apt-get -y install unzip"
    ]
  }

  # This package will allow us to mount a share drive that we can use to backup server data
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "apt-get update",
      "apt-get -y install cifs-utils"
    ]
  }

  # We use the grep package to extract the correct download link from the page we grabbed using curl.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install grep"]
  }

  # Screen will make accessing the servers command line easier remotely when we run the server as a service.
  # This package allows us to create a detached screen where the Bedrock server will run.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install screen"]
  }

  # The Minecraft Bedrock server requires the OpenSSL library to run.
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["apt-get -y install openssl"]
  }

  # required by Minecraft Bedrock
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -O libssl1.1.deb",
      "dpkg -i libssl1.1.deb",
      "rm libssl1.1.deb"
      ]
  }

  # Setup Minecraft User Account
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "useradd -m mcserver",
      "usermod -a -G mcserver $USER",
      "mkdir -p /home/mcserver/minecraft_bedrock"
      ]
  }

  # Download/Install latest version of Minecraft
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "DOWNLOAD_URL=$(curl -H \"Accept-Encoding: identity\" -H \"Accept-Language: en\" -s -L -A \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)\" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https://minecraft.azureedge.net/bin-linux/[^\"]*')",
      "wget $DOWNLOAD_URL -O /home/mcserver/minecraft_bedrock/bedrock-server.zip",
      "unzip /home/mcserver/minecraft_bedrock/bedrock-server.zip -d /home/mcserver/minecraft_bedrock/",
      "rm /home/mcserver/minecraft_bedrock/bedrock-server.zip",
      "chown -R mcserver: /home/mcserver/"
      ]
  }

  # Minecraft start_server.sh
  provisioner "file" {
    source = "./files/start_server.sh"
    destination = "/tmp/start_server.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/start_server.sh /home/mcserver/minecraft_bedrock/",
      "chmod +x /home/mcserver/minecraft_bedrock/start_server.sh"
    ]
  }

  # Minecraft stop_server.sh
  provisioner "file" {
    source = "./files/stop_server.sh"
    destination = "/tmp/stop_server.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/stop_server.sh /home/mcserver/minecraft_bedrock/",
      "chmod +x /home/mcserver/minecraft_bedrock/stop_server.sh"
    ]
  }

  # Server Properties
  provisioner "file" {
    source = "./files/server.properties"
    destination = "/tmp/server.properties"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/server.properties /home/mcserver/minecraft_bedrock/",
      "chmod +rX /home/mcserver/minecraft_bedrock/server.properties"
    ]
  }

  # Permissions
  provisioner "file" {
    source = "./files/permissions.json"
    destination = "/tmp/permissions.json"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/permissions.json /home/mcserver/minecraft_bedrock/",
      "chmod +rX /home/mcserver/minecraft_bedrock/permissions.json"
    ]
  }

  # Allow List
  provisioner "file" {
    source = "./files/allowlist.json"
    destination = "/tmp/allowlist.json"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/allowlist.json /home/mcserver/minecraft_bedrock/",
      "chmod +rX /home/mcserver/minecraft_bedrock/allowlist.json"
    ]
  }

  # Backup Minecraft Script
  provisioner "file" {
    source = "./files/backup_minecraft.sh"
    destination = "/tmp/backup_minecraft.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/backup_minecraft.sh /home/mcserver/minecraft_bedrock/",
      "chmod +rX /home/mcserver/minecraft_bedrock/backup_minecraft.sh"
    ]
  }

  # Upgrade Minecraft Script
  provisioner "file" {
    source = "./files/upgrade_minecraft.sh"
    destination = "/tmp/upgrade_minecraft.sh"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "cp /tmp/upgrade_minecraft.sh /home/mcserver/minecraft_bedrock/",
      "chmod +rX /home/mcserver/minecraft_bedrock/upgrade_minecraft.sh"
    ]
  }

  # add CIFS mount
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "echo '//${var.file_server}/${var.share_name} ${var.share_path} cifs username=${var.share_username},password=${var.share_password},uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab"
    ]
  }

  # Minecraft Settings
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "sed -i 's/\\[server_name\\]/${var.minecraft_server_name}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[game_mode\\]/${var.minecraft_game_mode}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[difficulty\\]/${var.minecraft_difficulty}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[allow_cheats\\]/${var.minecraft_allow_cheats}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[max_players\\]/${var.minecraft_max_players}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[allow_list\\]/${var.minecraft_allow_list}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[level_name\\]/${var.minecraft_level_name}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[level_seed\\]/${var.minecraft_level_seed}/g' /home/mcserver/minecraft_bedrock/server.properties",
      "sed -i 's/\\[default_player_permission_level\\]/${var.minecraft_detault_permission_level}/g' /home/mcserver/minecraft_bedrock/server.properties"
    ]
  }

  # Minecraft Permissions
  provisioner "shell" {
    execute_command = local.execute_command
    inline = [
      "sed -i 's/\\[admin_xuid\\]/${var.minecraft_operator}/g' /home/mcserver/minecraft_bedrock/permissions.json",
    ]
  }

  # Minecraft systemctl service
  provisioner "file" {
    source = "./files/mcbedrock.service"
    destination = "/tmp/mcbedrock.service"
  }
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["cp /tmp/mcbedrock.service /etc/systemd/system/"]
  }
  
  provisioner "shell" {
    execute_command = local.execute_command
    inline = ["chown -R mcserver: /home/mcserver/"]
  }

}