output "vpc_id" {
  value = module.network.vpc_id
}

output "app_server_ip" {
  value = module.ec2_instances.app_server_public_ip
}

output "monitoring_server_ip" {
  value = module.ec2_instances.monitoring_server_public_ip
}
