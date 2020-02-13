variable "gcp_project" {
  description = "The name of the gcp project to use"
  type        = string
}

variable "gcp_region" {
  description = "The name of the gcp region to use"
  type        = string
}

variable "gcp_zone" {
  description = "The name of the gcp zone to use"
  type        = string
}

variable "network_routing_mode" {
  description = "The routing mode to use for the network"
  type        = string
  default     = "GLOBAL"
}

variable "subnet_cidr" {
  description = "The CIDR of the subnet that will be created"
  type        = string
  default     = "10.10.10.0/24"
}

variable "tags" {
  description = "A map of tags to pass through to the underlying resources"
  type        = map
  default     = {}
}

########### connection settings ##################

variable "user_name" {
  description = "The ssh or winrm user name, used to create users on the target servers, if the create_user variable is set to true"
  type        = string
}

variable "user_pass" {
  description = "The password to set for the ssh or winrm user"
  type        = string
  default     = ""
}

variable "create_user" {
  description = "Should the user be created"
  type        = bool
  default     = true
}

variable "user_public_key" {
  description = "If set on linux systems and the create_user variable is true then the content from the file path provided in this variable will be added to the authorized_keys folder of the newly created user"
  type        = string
  default     = ""
}

variable "user_private_key" {
  description = "This needs to be set to the path of the private key pair that matches the provided public key. it is used when creating the guacamole connection data. Setting it allowd the guacamole client/server to ssh to the targets. can be ignored if using ssh passwords"
  type    = string
  default = ""
}

variable "populate_hosts" {
  description = "Set an entry in /etc/hosts for equivilent to `echo \"$(hostname -I) $(hostname)\" >> /etc/hosts`"
  type        = bool
  default     = false
}

variable "tmp_path" {
  description = "The location of the temp path to use for downloading installers and executing scripts"
  type        = string
  default     = "/var/tmp/server_bootstrap"
}

variable "set_hostname" {
  description = "Should we set the hostname to the instance name on linux systems"
  type        = bool
  default     = true
}

variable "ip_hostname" {
  description = "Should we append the ip address to help make hostnames unique when creating a batch of linux servers"
  type        = bool
  default     = true
}

variable "disk_type" {
  description = "URL of the disk type resource describing which disk type to use to create the disk. Provide this when creating the disk"
  type        = string
  default     = "pd-ssd"
}

variable "disk_size" {
  description = "Size of the persistent disk, specified in GB. You can specify this field when creating a persistent disk using the image or snapshot paramete"
  type        = number
  default     = 40
}

variable "disk_image" {
  description = "the image from which to initialize this disk"
  type        = string
  default     = "centos-7-v20200205"
}

variable "machine_type" {
  description = "The machine type to build e.g. n1-standard-4."
  type        = string
  default     = "n1-standard-4" 
}

variable "auto_delete_disk" {
  description = "Should the persistent volume be deleted upon termination of the vm"
  type        = bool
  default     = false
}

variable "chef_automate_count" {
  description = "the number of chef automate servers to create: multiple instances no implemented yet. do not use more than one"
  type        = number
  default     = 1
}

variable "chef_automate_version" {
  description = "The version of chef automate to install. defaults to latest"
  type        = string
  default     = "latest"
}

variable "chef_automate_license" {
  description = "The chef automate license string, can be left blank for no license"
  type        = string
  default     = ""
}

variable "chef_automate_data_collector_token" {
  description = "The data collector token to use for chef automate. can be left blank for a randomly generated token"
  type        = string
  default     = ""
}

variable "chef_automate_admin_password" {
  description = "The admin password for chef automate. Can be left blank for a randomly generated password"
  type        = string
  default     = ""
}

variable "chef_automate_enabled_profiles" {
  description = "A list of profiles to enable on the chef automate server"
  type        = list
  default     = []
}
