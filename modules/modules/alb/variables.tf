variable "alb_name" {
    description = "The name of the alb."
    default = ""
}
variable "aws_public_subnets" {
    description = "The public subnets."
    default     = ""
}
variable "aws_alb_security_group_id" {
    description = "The alb security group name"
    default     = ""
}
variable "alb_target_group_name" {
    description = "The target group name"
    default     = ""
}
variable "vpc_id" {
    description = "The VPC id."
    default     = ""
}
variable "health_check_path" {
    description = "The path health check."
    default     = "/"
}
variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default     = 80
}
variable "certificate_arn_attach_alb_listener" {
    description = "The ARN of the certificate to attach to the listener."
    default     = ""
}
variable "is_ssl" {
    description = "Set ssl for alb listener"
    default     = true
}
variable "ec2_target_id" {
    description = "EC2 Target id"
    default     = ""
}