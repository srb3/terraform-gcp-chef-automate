output "chef_automate_public_ip" {
  value = module.chef_automate.ip
}

output "chef_automate_UI_url" {
  value = module.chef_automate.url 
}

output "chef_automate_data_collector_token" {
  value = module.chef_automate.data_collector_token 
}

output "chef_automate_data_collector_url" {
  value = module.chef_automate.data_collector_url 
}

output "chef_automate_UI_admin_user" {
  value = module.chef_automate.admin_user
}

output "chef_automate_UI_admin_pass" {
  value = module.chef_automate.admin_pass 
}

output "chef_automate_ssh_user" {
  value = module.chef_automate.ssh_user
}
