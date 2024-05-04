
output "droplet_ip" {
  value = digitalocean_droplet.vps.ipv4_address
}
output "ansible_stdout" {
  value = ansible_playbook.playbook.ansible_playbook_stdout
}