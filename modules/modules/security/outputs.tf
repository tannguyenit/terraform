output "alb_security_group_id" {
    description = "The ALB security group id"
    value       = aws_security_group.alb.id
}
output "ec2_private_security_group_id" {
    description = "The EC2 private security group id"
    value       = aws_security_group.ec2_app.id
}
