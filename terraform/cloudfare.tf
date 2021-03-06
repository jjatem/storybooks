provider "cloudflare" {
  version   = "~> 2.0"
  api_token = var.cloudflare_api_token
}

## DNS ZONE

data "cloudflare_zones" "cf_zones" {
  filter {
    name = var.domain
  }
}

## DNS A RECORD
# Add a record to the domain
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zones.cf_zones.zones[0].id
  name    = "storybooks${terraform.workspace == "prod" ? "" : "-${terraform.workspace}"}"
  value   = google_compute_address.ip_address.address
  type    = "A"
  proxied = true
}


