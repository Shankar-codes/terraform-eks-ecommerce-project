resource "aws_lb" "ingress_alb" {
  name               = "${var.project_name}-ingress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.ingress_alb_sg_id]
  subnets            = local.public_subnet_ids

  #enable_deletion_protection = true

  tags = merge(local.common_tags, {
    Name = "${local.common_name_suffix}-ingress-alb"
  })
}


resource "aws_lb_listener" "ingress_alb" {
  load_balancer_arn = aws_lb.ingress_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.ingress_alb_certificate_arn

    default_action {
        type = "fixed-response"

        fixed_response {
        content_type = "text/html"
        message_body = "<h1>Welcome to the Ingress ALB</h1>"
        status_code  = "200"
        }
    }
}

resource "aws_route53_record" "ingress_alb" {
  zone_id = var.zone_id
  name    = "*.${var.domain_name}" #*.ellamma.fun
  type    = "A"
  allow_overwrite = true
  
  # these are details of aws alb
  alias {
    name                   = aws_lb.ingress_alb.dns_name
    zone_id                = aws_lb.ingress_alb.zone_id
    evaluate_target_health = true
  }
  
}