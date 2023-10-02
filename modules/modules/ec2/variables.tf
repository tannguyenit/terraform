variable "ec2_instance_name" {
    description = "Name to be used on all the resources as identifier"
    default     = ""
}
variable "instance_type" {
    description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
    default     = ""
}
variable "ami" {
    description = "The AMI to use for the instance."
    default     = ""
}
variable "security_group_id" {
    description = "The security group id."
    default     = ""
}
variable "private_subnet_ids" {
    description = "The private subnet id."
    default     = []
}
variable "key_pair_name" {
    description = "The name key pair."
    default     = ""
}
variable "iam_instance_profile" {
    description = "The iam instance profile."
    default     = ""
}
variable "number_instances" {
    description = "The number instances."
    default     = 1
}
variable "ssh_port" {
    description = "The ssh port."
    default     = 22
}
variable "is_bastion" {
    description = "The flag determine ec2 is bastion or private instance"
    default     = false
}