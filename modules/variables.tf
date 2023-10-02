variable "default_tags" {
  type    = map(string)
  default = {}
}

# Variables specify the provider
variable "aws_region" {
    description = "The region AWS"
    default     = "us-west-1"
}
variable "aws_access_key" {
    description = "The AWS access key"
    default     = ""
}
variable "aws_secret_key" {
    description = "The AWS secret key"
    default     = ""
}
variable "project_name" {
    description = "The Project name"
    default     = ""
}
variable "env" {
    description = "The environment"
    default     = ""
}
# End variables specify the provider

# Variables network
variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    default = "172.17.0.0/16"
}
variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default     = 2
}
variable "vpc_id" {
    description = "The VPC ID"
    default = ""
}
variable "is_exists_vpc" {
    description = "The state for exists VPC"
    default = false
}
# End variables network

# Variables Security group 
variable "alb_security_group_description" {
    description = "The security group description."
    default     = ""
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default     = 80
}

variable "ec2_security_group_description" {
    description = "The description security group"
    default     = ""
}
variable "ec2_bashtion_security_group_description" {
    description = "The description security group"
    default     = ""
}
variable "ec2_bastion_ssh_port" {
    description = "The ec2 bastion ssh port."
    default     = 22
}
variable "ec2_private_ssh_port" {
    description = "The ec2 application ssh port."
    default     = 22
}

# EC2 bastion
variable "instance_type" {
    description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
    default     = ""
}
variable "ami" {
    description = "The AMI to use for the instance."
    default     = ""
}
variable "number_instances" {
    description = "The number instances."
    default     = 1
}
# Cert attach for ALB
variable "route53_zone_name" {
    description = "The Hosted Zone name of the desired Hosted Zone"
    default     = ""
}
variable "route53_private_zone" {
    description = "Used with name field to get a private Hosted Zone"
    default = false
}
variable "alb_certificate_domain_name" {
    description = "A domain name for which the certificate should be issued"
    default = ""
}
variable "alb_subject_alternative_names" {
    description = "Set of domains that should be SANs in the issued certificate. To remove all elements of a previously configured list"
    default = []
}

# Variables for ALB
variable "alb_name" {
    description = "The name of the alb."
    default = ""
}
variable "alb_target_group_name" {
    description = "The target group name"
    default     = ""
}
variable "health_check_path" {
    description = "The path health check."
    default     = "/"
}

variable "is_ssl" {
    description = "Set ssl for alb listener"
    default     = true
}
# End Variables for ALB

# Variables for RDS
variable "rds_security_group_description" {
    description = "The description of security group of rds"
    default = ""
}
variable "rds_port" {
    description = "The rds port"
    default     = ""
}

# End Variables for ALB
