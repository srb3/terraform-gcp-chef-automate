# Overview
This terraform will create:
 network and subnet
 firewall rules for 80,443 from any source for the network
 a chef automate instance in gcp

### Supported platform families:
 * Debian
 * SLES
 * RHEL

## Usage

```
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|gcp_project|A list of ip addresses where the chef automate will be installed|list|[]|no|
|gcp_region|The number of instances being created|number|1|no|
|gcp_zone|The ssh user name used to access the ip addresses provided|string||yes|
|network_routing_mode|The ssh user password used to access the ip addresses (either ssh_user_pass or ssh_user_private_key needs to be set)|string|""|no|
|subnet_cidr|The ssh user key used to access the ip addresses (either ssh_user_pass or ssh_user_private_key needs to be set)|string|""|no|
|tags|The install channel to use for the chef automate package|string|current|no|
|user_name|The version of chef automate to install|string|latest|no|
|user_pass|Any extra config that needs to be passed to the automate server can be placed in this string|string|""|no|
|create_user|Shall we accept the chef product license|boolean|true|no|
|user_public_key|The token used to access the data collector end point|string|""|no|
|user_private_key|Sets the automate admin password|string|""|no|
|populate_hosts|Set an entry in /etc/hosts for equivilent to `echo \"$(hostname -I) $(hostname)\">> /etc/hosts`|bool|false|no|
|tmp_path|The location of the temp path to use for downloading installers and executing scripts|string|/var/tmp/server_bootstrap|no|
|set_hostname|Should we set the hostname to the chef autoamte instance|bool|true|no|
|disk_type|URL of the disk type resource describing which disk type to use to create the disk|string|pd-ssd|no|
|disk_size|Size of the persistent disk, specified in GB. You can specify this field when creating a persistent disk using the image or snapshot paramete|number|40|no|
|disk_image|the image from which to initialize this disk|string|centos-7-v20200205|no|
|machine_type|he machine type to build|default|n1-standard-4|no|
|auto_delete_disk|Should the persistent volume be deleted upon termination of the vm"|bool|true|no|
|chef_automate_count|the number of chef automate servers to create: multiple instances no implemented yet. do not use more than one|number|1|no|
|chef_automate_version|The version of chef automate to install. defaults to latest|string|latest|no|
|chef_automate_license|the chef automate license string, can be left blank for no license|string|""|no|
|chef_automate_data_collector_token|The data collector token to use for chef automate. can be left blank for a randomly denerated token|string|""|no|
|chef_automate_admin_password|The admin password for chef automate. Can be left blank for a randomly generated password|string|""|no|
|chef_automate_enabled_profiles|A list of profiles to enable on the chef automate server. see terraform.tfvars.example for details|list|[]|no|
