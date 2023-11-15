provider "openstack" {
  region = var.region_name
}

data "openstack_images_image_v2" "image" {
  name        = var.image_name
  most_recent = true
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

resource "tls_private_key" "ssh_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

#
# Network objects
#
data "openstack_networking_network_v2" "ext_net" {
  name      = var.ext_net_name
  tenant_id = ""
}

resource "openstack_networking_network_v2" "vrack" {
  name           = var.name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = var.name
  network_id      = openstack_networking_network_v2.vrack.id
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = var.dns_nameservers
  enable_dhcp     = true
  gateway_ip      = cidrhost(var.subnet_cidr, 1)
}

resource "openstack_networking_router_v2" "router" {
  name                = var.name
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_port_v2" "router" {
  name           = "${var.name}-gw"
  network_id     = openstack_networking_subnet_v2.subnet.network_id
  admin_state_up = "true"

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet.id
    ip_address = cidrhost(var.subnet_cidr, 1)
  }
}

resource "openstack_networking_router_interface_v2" "interface" {
  router_id = openstack_networking_router_v2.router.id
  port_id   = openstack_networking_port_v2.router.id
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool    = var.ext_net_name
  port_id = openstack_networking_port_v2.port.id
}

#
# Security group objects for ssh
#
resource "openstack_networking_secgroup_v2" "ingress" {
  name        = var.name
  description = "${var.name} for ingress traffic"
}

resource "openstack_networking_secgroup_rule_v2" "ingress_ssh" {
  for_each = var.allowed_prefixes

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = each.value
  security_group_id = openstack_networking_secgroup_v2.ingress.id
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = var.name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "openstack_networking_port_v2" "port" {
  name           = var.name
  network_id     = openstack_networking_network_v2.vrack.id
  admin_state_up = "true"

  security_group_ids = [openstack_networking_secgroup_v2.ingress.id]
}

resource "openstack_compute_instance_v2" "host" {
  name = var.name

  image_id  = data.openstack_images_image_v2.image.id
  flavor_id = data.openstack_compute_flavor_v2.flavor.id
  key_pair  = openstack_compute_keypair_v2.keypair.name

  network {
    port           = openstack_networking_port_v2.port.id
    access_network = true
  }

  lifecycle {
    # ignore image id change because provider may update the image
    # regularly. To update the image, the resource has to be
    # explicitely tainted.
    ignore_changes = [image_id, flavor_id]
  }
}

resource "terraform_data" "post_install" {
  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.fip.address
      user        = var.ssh_user
      private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = [
      "echo 'connected!'",
      "/usr/bin/cloud-init status --wait",
    ]
  }

  provisioner "file" {
    connection {
      host        = openstack_networking_floatingip_v2.fip.address
      user        = var.ssh_user
      private_key = tls_private_key.ssh_key.private_key_pem
    }
    source      = "../../../ansible"
    destination = "/tmp/ansible"
  }

  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.fip.address
      user        = var.ssh_user
      private_key = tls_private_key.ssh_key.private_key_pem
    }
    inline = [
      "sudo apt update && sudo apt install -y ansible",
      "ansible-galaxy install --force xanmanning.k3s",
      "ansible-playbook --become -c local --inventory='localhost,' /tmp/ansible/playbooks/playbook.yml",
    ]
  }
}
