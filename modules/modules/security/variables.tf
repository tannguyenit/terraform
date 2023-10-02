variable "alb_security_group_name" {
    description = "The name of the security group for alb."
    default = ""
}
variable "alb_security_group_description" {
    description = "The security group description for alb."
    default     = ""
}
variable "vpc_id" {
    description = "The VPC ID"
    default     = ""
}
variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default     = 80
}
variable "ssh_port" {
    description = "The ssh port."
    default     = 22
}
variable "ec2_private_ssh_port" {
    description = "The ec2 private ssh port."
    default     = 22
}
variable "rds_security_group_name" {
    description = "The security group name for rds."
    default     = ""
}
variable "rds_security_group_description" {
    description = "The security group description for rds."
    default     = ""
}
variable "vpc_cidr_block" {
    description = "The vpc cidr block."
    default     = ""
}
variable "ec2_security_group_name" {
    description = "The security group name for ec2."
    default     = ""
}
variable "ec2_security_group_description" {
    description = "The security group description for ec2."
    default     = ""
}

variable "ec2_bastion_security" {
    description = "The security group description for ec2."
    default     = ""
}
