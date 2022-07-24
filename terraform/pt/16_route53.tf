#도메인 영역
resource "aws_route53_zone" "route53_zone" {
  name       = var.domain
}

#로드발란서 레코드
resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = "${format("%s.%s", "www", var.domain)}"
  type    = "A"

  alias {
    name                   = "dualstack.${aws_lb.alb.dns_name}"
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

#CDN 레코드
resource "aws_route53_record" "s3" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = "${format("%s.%s", "home", var.domain)}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

