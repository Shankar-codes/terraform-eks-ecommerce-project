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

# target group for the frontend instance
resource "aws_lb_target_group" "frontend" {
  name     = "${local.common_name_suffix}-frontend"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = local.vpc_id
  deregistration_delay = 60 #waiting for 60 seconds before deregistering the instance from the target group
  health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    interval            = 10
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# you must install the AWS load balancer for this or else traffic wont go to dev.ellamma.com
resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.ingress_alb.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["dev.${var.domain_name}"] # if any once access dev.ellamma.fun
    }
  }
}