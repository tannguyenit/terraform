output "ec2_id" {
    description = "The alb target group id"
    value       = aws_instance.Amazon_Linux_2[0].id
}