### General variables
variable "app_name" {
  type    = string
  default = "storybooks"
}

### GCP

variable "gcp_machine_type" {
  type    = string
  default = "f1-micro"
}

### ATLAS

variable "atlas_project_id" {
  type = string
}

variable "atlas_username" {
  type = string
}

variable "atlas_user_password" {
  type = string
}

variable "mongodbatlas_public_key" {
  type = string
}

variable "mongodbatlas_private_key" {
  type = string
}

### CLOUDFARE

variable "cloudflare_api_token" {
  type = string
}
