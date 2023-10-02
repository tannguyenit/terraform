output "alb_target_group_id" {
  description = "The alb target group id"
  value       = aws_alb_target_group.app.id
}
output "alb_dns_name" {
  description = "The alb DNS_Name"
  value       = aws_alb.main.dns_name
}

output "alb_zone_id" {
  description = "The alb DNS_Name"
  value       = aws_alb.main.zone_id
}
