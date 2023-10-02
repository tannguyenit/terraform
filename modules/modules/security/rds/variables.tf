variable "vpc_id" {
    description = "The VPC ID"
    default     = ""
}
variable "rds_security_group_name" {
    description = "The security group name for rds."
    default     = ""
}
variable "rds_security_group_description" {
    description = "The security group description for rds."
    default     = ""
}
variable "rds_port" {
    description = "The rds from port."
    default     = 3306
}
variable "vpc_cidr_block" {
    description = "The vpc cidr block."
    default     = ""
}

variable "security_group_id" {
    description = "Security group id access to rds"
    default     = ""
}