output "ipv4" {
  description = "ipv4 of the host"
  value       = openstack_compute_instance_v2.host.access_ip_v4
}

output "fip" {
  description = "fip of the host"
  value       = openstack_networking_floatingip_v2.fip.address
}

output "ssh_keypair" {
  description = "ssh_keypair to be used on infra"
  sensitive   = true
  value = {
    priv = tls_private_key.ssh_key.private_key_pem
    pub  = tls_private_key.ssh_key.public_key_openssh
  }
}
