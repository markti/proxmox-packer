#!/bin/bash

now=`date +"%Y-%m-%d"`

# Grant read access to the ubuntu user recursively
sudo setfacl -R -m u:ubuntu:rX /home/mcserver/minecraft_bedrock/worlds

# Perform the backup with verbose output
tar -cvpzf /mnt/minecraft/minecraft-backup${now}.tar.gz /home/mcserver/minecraft_bedrock/worlds