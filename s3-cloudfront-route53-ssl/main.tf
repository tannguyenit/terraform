provider "aws" {
  region = "us-west-2"
}

data "aws_route53_zone" "public" {
  name         = var.rootDomain
  private_zone = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.domainName
  force_destroy = true

  tags = {
    Name        = var.domainName
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_cloudfront_origin_access_identity" "cloudfrontOAI" {
  comment = "access-identity-${var.domainName}.s3.amazonaws.com"
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfrontOAI.iam_arn]
    }
  }
}

resource "aws_cloudfront_distribution" "my_cloudfront" {
  depends_on = [
    aws_s3_bucket.bucket
  ]

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = "s3-cloudfront"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfrontOAI.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domainName]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-cloudfront"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_200"

  tags = {
    Environment = "Dev"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = var.acmCertificateArn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1"
  }
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.public.id
  name    = var.domainName

  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.my_cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}
