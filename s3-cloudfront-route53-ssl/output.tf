output "dns" {
  value = aws_cloudfront_distribution.my_cloudfront.domain_name
}

output "route" {
  value = aws_route53_record.web.name
}
