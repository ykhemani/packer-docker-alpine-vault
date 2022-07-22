packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.0.5"
    }
  }
}

source "docker" "image" {
  image          = "${var.source_image}:${var.source_image_version}"
  login_server   = var.source_image_server
  login_username = var.source_image_username
  login_password = var.source_image_password
  commit         = true
  changes = [
    "EXPOSE 8200",
    "VOLUME /vault/logs /vault/data /vault/certs",
    "LABEL version=${var.vault_version}",
    "ENTRYPOINT /bin/vault server -dev"
  ]
}

build {

  sources = [
    "sources.docker.image"
  ]

  provisioner "shell" {
    inline = [
      "apk update",
      "apk add --no-cache wget unzip bash ca-certificates gnupg openssl libcap su-exec dumb-init tzdata"
    ]
  }

  provisioner "shell" {
    script = "alpine-vault-install.sh"
    env = {
      VAULT_VERSION = var.vault_version
    }
  }

  post-processors {
    post-processor "docker-tag" {
      repository = var.target_image_name
      tags       = ["${var.target_image_version}"]
    }
    post-processor "docker-push" {
      login_server   = var.target_image_server
      login_username = var.target_image_username
      login_password = var.target_image_password
    }
  }

  hcp_packer_registry {
    bucket_name = var.bucket_name
    description = "Alpine Vault Container Image"
    bucket_labels = {
      "app" = "vault"
    }
    build_labels = {
      "version" = var.vault_version
      "alpine"  = var.source_image_version
    }
  }
}
