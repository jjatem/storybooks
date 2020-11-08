provider "cloudflare" {
  version = "~> 2.0"
  token   = var.cloudflare_api_token
}

## DNS ZONE

data "cloudflare_zone" "cf_zones" {
  filter = var.domain
}

## DNS A RECORD
# Add a record to the domain
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudfare_zones.cf_zones.zones[0].id
  name    = "storybooks${terraform.workspace == "prod" ? "" : "-${terraform.workspace}"}"
  value   = google_compute_address.ip_address.address
  type    = "A"
  proxied = true
}


