# Overview
This terraform will create:
 * network and subnet
 * firewall rules for 80,443 from any source for the network
 * a chef automate instance in gcp

### Prerequisites
before you run terraform, the GOOGLE_CLOUD_KEYFILE_JSON environment vairable needs to be set
```
export GOOGLE_CLOUD_KEYFILE_JSON=</path/to/gcp/creds.json>
```

### Supported platform families:
 * Debian
 * SLES
 * RHEL

## Usage

```
export GOOGLE_CLOUD_KEYFILE_JSON=</path/to/gcp/creds.json>
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|gcp_project|the name of the project to create resources|string||yes|
|gcp_region|The name of the GCP region to use|string||yes|
|gcp_zone|The name of the gcp zone to use|string||yes|
|network_routing_mode|The routing mode to use for the network|string|GLOBAL|no|
|subnet_cidr|The CIDR of the subnet that will be created|string|10.10.10.0/24|no|
|tags|A map of tags to pass through to the underlying resources - see terraform.tfvars.example for details|map|{}|no|
|user_name|The ssh user name, used to create users on the target servers, if the create_user variable is set to true|string|latest|no|
|user_pass|The password to set for the ssh user, not need if using public key|string|""|no|
|create_user|Should the user be created|boolean|true|no|
|user_public_key|Needed if not useing password, this is the path to an ssh public key. the key content will be injected into the authoried keys file for the user specified in user_name|string|""|no|
|user_private_key|The path to the private key that matches the public key if one has been specifed. used by terraform modules to access the instance|string|""|no|
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
