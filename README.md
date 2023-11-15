DESCRIPTION
----

This repository boots a VM in OVH Public cloud and installs a fresh k3s service.


``` sh
source path/to/openrc
cd terraform/root-modules/host
terraform init
terraform apply -var flavor_name=??? -var region_name=???
```

