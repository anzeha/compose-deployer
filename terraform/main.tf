terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    ansible = {
      version = "~> 1.2.0"
      source  = "ansible/ansible"
    }
    htpasswd = {
      version = "~> 1.2.1"
      source = "loafoe/htpasswd"
    }

  }
}
    
provider "htpasswd" {
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.digital_ocean_token
}

# Configure ssh key to access the droplet
resource "digitalocean_ssh_key" "default" {
  name       = var.ssh_key_name
  public_key = file("./keys/id_rsa.pub")
}

resource "digitalocean_droplet" "vps" {
  image       = var.droplet_image
  name        = var.droplet_name
  region      = var.droplet_region
  size        = var.droplet_size
  resize_disk = var.droplet_resize_disk
  ssh_keys    = [digitalocean_ssh_key.default.fingerprint]

}

resource "digitalocean_project" "project" {
  name      = var.project_name
  resources = [digitalocean_droplet.vps.urn]
  depends_on = [ digitalocean_droplet.vps ]
}

# resource "ansible_host" "host" {
#   name = digitalocean_droplet.vps.ipv4_address
  

#   variables = {
#     ansible_hostname             = digitalocean_droplet.vps.ipv4_address
#     ansible_user                 = "root"
#     ansible_ssh_private_key_file = "./keys/id_rsa"
#     ansible_python_interpreter   = "/usr/bin/python3"
#   }
# }


resource "htpasswd_password" "hash" {
  password = var.traefik_basic_auth_password
}


resource "ansible_playbook" "playbook" {
  playbook                = "../ansible/main.yml"
  name                    = digitalocean_droplet.vps.ipv4_address
  replayable              = var.ansible_playbook_replayable
  ignore_playbook_failure = var.ansible_ignore_playbook_failure
  verbosity = var.ansible_playbook_verbosity
  depends_on = [ digitalocean_project.project ]

  extra_vars = {
    ansible_hostname             = digitalocean_droplet.vps.ipv4_address
    ansible_user                 = "root"
    ansible_ssh_private_key_file = "./keys/id_rsa"
    ansible_python_interpreter   = "/usr/bin/python3"

    docker_network_name = var.docker_network_name
    dynamic_dns_domain = var.dynamic_dns_domain
    dynamic_dns_update_url = var.dynamic_dns_update_url
    production = var.production
    acme_endpoint = var.production ? var.acme_endpoint_production : var.acme_endpoint_staging
    basic_auth_user_pass = "${var.traefik_basic_auth_username}:${htpasswd_password.hash.bcrypt}"

  }
}