module "network" {
  source = "./modules/network"

  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.network.vpc_id
}

module "ec2_instances" {
  source                   = "./modules/ec2"
  instance_type_app        = var.instance_type_app
  instance_type_monitoring = var.instance_type_monitoring
  ami                      = var.ami
  key_pair                 = var.key_pair
  app_port                 = var.app_port
  public_subnet_id         = module.network.public_subnet_id
  app_sg_id                = module.security_groups.app_sg_id
  monitoring_sg_id         = module.security_groups.monitoring_sg_id
  mysql_root_password      = var.mysql_root_password
  mysql_database           = var.mysql_database
  mysql_user               = var.mysql_user
  mysql_password           = var.mysql_password
}

