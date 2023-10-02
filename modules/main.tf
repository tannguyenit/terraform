
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create Network and VPC
module "network" {
  source              = "./modules/network"
  aws_vpc_cidr_block  = var.vpc_cidr_block
  az_count            = var.az_count
  vpc_name            = "vpc-${var.project_name}-${var.env}"
  subnet_private_name = "private-subnet-${var.project_name}-${var.env}"
  subnet_public_name  = "public-subnet-${var.project_name}-${var.env}"
}

# Key pair
module "key_pair" {
  source   = "./modules/key_pair"
  key_name = "${var.project_name}-${var.env}"
}

# Create Security group
module "security" {
  source                         = "./modules/security"
  alb_security_group_name        = "alb-sg-${var.project_name}-${var.env}"
  alb_security_group_description = var.alb_security_group_description
  ec2_security_group_name        = "ec2-sg-${var.project_name}-${var.env}"
  ec2_security_group_description = var.ec2_security_group_description
  vpc_id                         = module.network.vpc_id
  app_port                       = var.app_port
  ec2_private_ssh_port           = var.ec2_private_ssh_port
  ec2_bastion_security           = module.ec2_bastion_security.ssh_security_group_id
  vpc_cidr_block                 = module.network.vpc_cidr_block
}

# Create EC2 bastion security group
module "ec2_bastion_security" {
  source                         = "./modules/security/ec2"
  vpc_id                         = module.network.vpc_id
  ec2_security_group_name        = "bastion-ec2-sg-${var.project_name}-${var.env}"
  ec2_security_group_description = var.ec2_bashtion_security_group_description
  ingress_ssh_port               = var.ec2_bastion_ssh_port
}

# Create RDS security group
module "rds_security" {
  source                         = "./modules/security/rds"
  vpc_id                         = module.network.vpc_id
  rds_security_group_name        = "rds-sg-${var.project_name}-${var.env}"
  rds_security_group_description = var.rds_security_group_description
  rds_port                       = var.rds_port
  security_group_id              = module.security.ec2_private_security_group_id
}

# EC2 bastion
module "ec2_bastion" {
  source             = "./modules/ec2"
  ec2_instance_name  = "bastion-${var.project_name}-${var.env}"
  ami                = var.ami
  is_bastion         = true
  security_group_id  = module.ec2_bastion_security.ssh_security_group_id
  key_pair_name      = module.key_pair.key_name
  instance_type      = var.instance_type
  number_instances   = var.number_instances
  private_subnet_ids = module.network.public_subnet_ids
  ssh_port           = var.ec2_bastion_ssh_port
}

# EC2 App
module "ec2_app" {
  source             = "./modules/ec2"
  ec2_instance_name  = "app-${var.project_name}-${var.env}"
  ami                = var.ami
  security_group_id  = module.security.ec2_private_security_group_id
  key_pair_name      = module.key_pair.key_name
  instance_type      = var.instance_type
  number_instances   = var.number_instances
  private_subnet_ids = module.network.app_private_subnet_ids
  ssh_port           = var.ec2_private_ssh_port
}

# Create cert for attach for ALB
module "alb_cert" {
  source                    = "./modules/certificate"
  route53_zone_name         = var.route53_zone_name
  route53_private_zone      = var.route53_private_zone
  certificate_domain_name   = var.alb_certificate_domain_name
  subject_alternative_names = var.alb_subject_alternative_names
}

# Create ALB
module "alb" {
  source                              = "./modules/alb"
  alb_name                            = "alb-${var.project_name}-${var.env}"
  aws_public_subnets                  = module.network.public_subnet_ids
  aws_alb_security_group_id           = module.security.alb_security_group_id
  alb_target_group_name               = "alb-tg-${var.project_name}-${var.env}"
  vpc_id                              = module.network.vpc_id
  health_check_path                   = var.health_check_path
  app_port                            = var.app_port
  is_ssl                              = var.is_ssl
  ec2_target_id                       = module.ec2_app.ec2_id
  certificate_arn_attach_alb_listener = module.alb_cert.acm_certificate_arn
}

# Create route53 record
module "route53" {
  source               = "./modules/route53"
  route53_zone_name    = var.route53_zone_name
  route53_private_zone = var.route53_private_zone
  alias_dns_name       = module.alb.alb_dns_name
  alias_zone_id        = module.alb.alb_zone_id
}
