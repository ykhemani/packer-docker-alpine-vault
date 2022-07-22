variable "source_image" {
  type        = string
  description = "The source image for the Docker container that will be started. This image will be pulled from the Docker registry if it doesn't already exist."
  default     = "alpine"
}

variable "source_image_version" {
  type        = string
  description = "Source image version."
  default     = "3.16.0"
}

variable "source_image_server" {
  type        = string
  description = "The source image server."
  default     = "https://hub.docker.com"
}

variable "source_image_username" {
  type        = string
  description = "The username for logging into the source image server."
}

variable "source_image_password" {
  type        = string
  description = "The password for logging into the source image server."
}

variable "vault_version" {
  type        = string
  description = "Version of Vault to install."
  default     = "1.11.0"
}

variable "hashicorp_releases" {
  type        = string
  description = "URL for HashiCorp releases"
  default     = "https://releases.hashicorp.com"
}

variable "bucket_name" {
  type        = string
  description = "Name of HCP Packer Registry Bucket"
  default     = "alpine-vault"
}

variable "target_image_server" {
  type        = string
  description = "The target image server."
  default     = "https://hub.docker.com"
}

variable "target_image_username" {
  type        = string
  description = "The username for logging into the target image server."
}

variable "target_image_password" {
  type        = string
  description = "The password for logging into the target image server."
}

variable "target_image_name" {
  type        = string
  description = "Name of target image."
  # default   = "ykhemani/vault"
}

variable "target_image_version" {
  type        = string
  description = "Container version"
  default     = "1.11.0"
}

