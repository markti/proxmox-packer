terraform {
  required_providers {
    minecraft = {
      source  = "HashiCraft/minecraft"
      version = "0.1.1"
    }
  }
}

provider "minecraft" {
  address  = var.server_address
  password = var.server_password
}