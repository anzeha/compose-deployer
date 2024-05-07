
output "droplet_ip" {
  value = digitalocean_droplet.vps.ipv4_address
}
output "bcrypt_hash" {
  value = htpasswd_password.hash.bcrypt
}
output "ansible_stdout" {
  value = ansible_playbook.playbook.ansible_playbook_stdout
}