terraform {
  required_version = "> 0.12.0"
}

provider "google" {
  project                 = var.gcp_project
  region                  = var.gcp_region
  zone                    = var.gcp_zone
}

resource "random_id" "hash" {
  byte_length = 4
}

locals {
  common_name      = "${lookup(var.tags, "prefix", "changeme")}-${random_id.hash.hex}"
  hostname         = "${local.common_name}-automate"
  user_private_key = var.user_private_key
  bootstrap = templatefile("${path.module}/templates/bootstrap.sh", {
    create_user               = var.create_user,
    user_name                 = var.user_name,
    user_pass                 = var.user_pass,
    user_public_key           = var.user_public_key != "" ? file(var.user_public_key) : var.user_public_key,
    tmp_path                  = var.tmp_path,
    hostname                  = local.hostname,
    ip_hostname               = var.ip_hostname,
    set_hostname              = var.set_hostname,
    populate_hosts            = var.populate_hosts
  })
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.1.1"

  project_id   = var.gcp_project
  network_name = "${local.common_name}-network"
  routing_mode = var.network_routing_mode

  subnets = [
    {
      subnet_name   = "automate-subnet"
      subnet_ip     = var.subnet_cidr
      subnet_region = var.gcp_region
    }
  ]


  routes = [
    {
      name                   = "egress-internet"
      description            = "route through IGW to access internet"
      destination_range      = "0.0.0.0/0"
      tags                   = "egress-inet"
      next_hop_internet      = "true"
    }
  ]
}

resource "google_compute_firewall" "default" {
  name    = "automate-firewall"
  network = module.vpc.network_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

} 

data "google_compute_zones" "available" {
  region = var.gcp_region
  status = "UP"
}

resource "google_compute_address" "instances" {
  name  = "${local.common_name}-address"
}

resource "google_compute_disk" "instances" {
  name = "${local.common_name}-disk"
  type = var.disk_type
  size = var.disk_size
  zone = data.google_compute_zones.available.names[0]
  image = var.disk_image
}

resource "google_compute_instance" "instances" {

  name         = local.hostname
  zone         = data.google_compute_zones.available.names[0]
  machine_type = var.machine_type

  boot_disk {
    source      = google_compute_disk.instances.name
    auto_delete = var.auto_delete_disk
  }
  
  metadata = {
    startup-script = local.bootstrap
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[0]

    access_config {
      nat_ip = google_compute_address.instances.address
    }
  }

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }
}

module "chef_automate" {
  source                = "srb3/chef-automate/linux"
  version               = "0.0.19"
  ips                   = [google_compute_instance.instances.network_interface.0.access_config.0.nat_ip]
  instance_count        = var.chef_automate_count
  install_version       = var.chef_automate_version
  ssh_user_name         = var.user_name
  ssh_user_private_key  = local.user_private_key
  chef_automate_license = var.chef_automate_license
  data_collector_token  = var.chef_automate_data_collector_token
  admin_password        = var.chef_automate_admin_password
}

module "populate_automate_server" {
  source                = "srb3/chef-automate-populate/linux"
  version               = "0.0.8"
  ip                    = google_compute_instance.instances.network_interface.0.access_config.0.nat_ip
  instance_count        = var.chef_automate_count
  user_name             = var.user_name
  automate_module       = jsonencode(module.chef_automate)
  user_private_key      = var.user_private_key
  enabled_profiles      = var.chef_automate_enabled_profiles
}
