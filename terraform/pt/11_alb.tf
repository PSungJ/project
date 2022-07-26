// ALB 생성
resource "aws_lb" "alb" {
  name                       = format("%s-alb", var.name)
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg_alb.id]
  subnets                    = aws_subnet.pub_sub.*.id
  enable_deletion_protection = false
}

// 타겟 그룹 생성
resource "aws_lb_target_group" "alb_target" {
  name        = format("%s-alb-tg", var.name)
  port        = var.alb_target.port
  protocol    = var.alb_target.protocol
  target_type = var.alb_target.target_type
  vpc_id      = aws_vpc.vpc.id

  health_check {
    enabled             = var.alb_target.health_enable
    healthy_threshold   = var.alb_target.healthy_threshold
    interval            = var.alb_target.interval
    matcher             = var.alb_target.matcher
    path                = var.alb_target.path
    port                = var.alb_target.h_port
    protocol            = var.alb_target.h_protocol
    timeout             = var.alb_target.timeout
    unhealthy_threshold = var.alb_target.unhealthy_threshold
  }
}

# LoadBalancer에 Listener 연결, 내부 Target 쪽으로 Forwarding
resource "aws_lb_listener" "alb_front_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert_valid.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}

resource "aws_lb_listener" "alb_front_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "alb_target_ass" {
  count            = var.web.count
  target_group_arn = aws_lb_target_group.alb_target.arn
  target_id        = aws_instance.web[count.index].id
  port             = "80"
}
