provider "google" {
  credentials = file("terraform-sa-key.json")
  project     = "storybooks-deveops-jj"
  region      = "us-central1"
  zone        = "us-central1-c"
  version     = "~> 3.38"
}

## static public IP address

resource "google_compute_address" "ip_address" {
  name = "storybooks-ip-${terraform.workspace}"
}

## NETWORK
data "google_compute_network" "default" {
  name = "default"
}

## FIREWALL RULE HTTP

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http--${terraform.workspace}"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-http-${terraform.workspace}"]
}

## OS IMAGE

data "google_compute_image" "my_image" {
  family  = "cos-81-lts"
  project = "cos-cloud"
}

## COMPUTE ENGINE INSTANCE - VM

resource "google_compute_instance" "instance" {
  name         = "${var.app_name}-vm-${terraform.workspace}"
  machine_type = var.gcp_machine_type
  zone         = "us-central1-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = google_compute_image.my_image
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
