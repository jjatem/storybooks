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
