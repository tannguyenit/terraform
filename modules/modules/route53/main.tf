data "aws_route53_zone" "selected" {
    name         = var.route53_zone_name
    private_zone = var.route53_private_zone
}

resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alias_dns_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = true
  }
}