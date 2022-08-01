resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "route53_record_cert" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn = aws_acm_certificate.cert.arn
}


resource "aws_acm_certificate" "certue" {
  provider                  = aws.us-east-1
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validue" {
  provider        = aws.us-east-1
  certificate_arn = aws_acm_certificate.certue.arn
}
