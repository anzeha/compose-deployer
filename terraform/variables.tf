#TERRAFORM VARS

variable "digital_ocean_token" {
  type = string
  sensitive = true
}
variable "ssh_key_name" {
  type = string
  default = "terraform_ssh_key"
}
variable "droplet_name" {
  type = string
  default = "mydroplet"
}
variable "droplet_image" {
  type = string
  default = "ubuntu-20-04-x64"
}
variable "droplet_region" {
  type = string
  default = "fra1"
}
variable "droplet_size" {
  type = string
  default = "s-1vcpu-512mb-10gb"
}
variable "droplet_resize_disk" {
  type = bool
  default = false
}
variable "project_name" {
  type = string
  default = "my_project"
  description = "Digital ocean project name"

# ANSIBLE VARS

}
variable "ansible_playbook_verbosity" {
  type = number
  default = 1
}
variable "ansible_playbook_replayable" {
  type = bool
  default = true
}
variable "ansible_ignore_playbook_failure" {
  type = bool
  default = false
}

# DOCKER VARS
variable "docker_network_name" {
  type = string
  default = "web"
}
variable "dynamic_dns_domain" {
  type = string
  description = "Domain name without http or https. Example: example.mysite.com"
}
variable "dynamic_dns_update_url" {
  type = string
  description = "Dynamic domain name update url"
}