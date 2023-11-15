<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.5.7 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | 1.53.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | 1.53.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [openstack_compute_instance_v2.host](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/compute_instance_v2) | resource |
| [openstack_compute_keypair_v2.keypair](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/compute_keypair_v2) | resource |
| [openstack_networking_floatingip_v2.fip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_floatingip_v2) | resource |
| [openstack_networking_network_v2.vrack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_network_v2) | resource |
| [openstack_networking_port_v2.port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.router](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_port_v2) | resource |
| [openstack_networking_router_interface_v2.interface](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_router_interface_v2) | resource |
| [openstack_networking_router_v2.router](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_router_v2) | resource |
| [openstack_networking_secgroup_rule_v2.ingress_ssh](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_v2.ingress](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_secgroup_v2) | resource |
| [openstack_networking_subnet_v2.subnet](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/resources/networking_subnet_v2) | resource |
| [terraform_data.post_install](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.2/docs/resources/private_key) | resource |
| [openstack_compute_flavor_v2.flavor](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/data-sources/compute_flavor_v2) | data source |
| [openstack_images_image_v2.image](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/data-sources/images_image_v2) | data source |
| [openstack_networking_network_v2.ext_net](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.53.0/docs/data-sources/networking_network_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_prefixes"></a> [allowed\_prefixes](#input\_allowed\_prefixes) | Allowed ingress prefixes | `set(string)` | <pre>[<br>  "109.190.254.0/24"<br>]</pre> | no |
| <a name="input_dns_nameservers"></a> [dns\_nameservers](#input\_dns\_nameservers) | DNS nameservers | `set(string)` | <pre>[<br>  "1.1.1.1"<br>]</pre> | no |
| <a name="input_ext_net_name"></a> [ext\_net\_name](#input\_ext\_net\_name) | Name of public openstack network | `string` | `"Ext-Net"` | no |
| <a name="input_flavor_name"></a> [flavor\_name](#input\_flavor\_name) | Flavor name | `string` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Image name to retrieve | `string` | `"Debian 12"` | no |
| <a name="input_name"></a> [name](#input\_name) | name of the deployment (used for resources names) | `string` | `"opencopilot-test"` | no |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | Openstack region name | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | user to ssh into the vm | `string` | `"debian"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | Subnet CIDR | `string` | `"10.0.0.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fip"></a> [fip](#output\_fip) | fip of the host |
| <a name="output_ipv4"></a> [ipv4](#output\_ipv4) | ipv4 of the host |
| <a name="output_ssh_keypair"></a> [ssh\_keypair](#output\_ssh\_keypair) | ssh\_keypair to be used on infra |
<!-- END_TF_DOCS -->