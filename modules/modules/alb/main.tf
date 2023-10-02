resource "aws_alb" "main" {
    name            = var.alb_name
    subnets         = var.aws_public_subnets
    security_groups = [var.aws_alb_security_group_id]
}

resource "aws_alb_target_group" "app" {
    name        = var.alb_target_group_name
    port        = var.app_port
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "instance"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = var.health_check_path
        unhealthy_threshold = "2"
    }
}

# Attach the target group for "test" ALB
resource "aws_lb_target_group_attachment" "tg_attachment" {
    target_group_arn = aws_alb_target_group.app.id
    target_id        = var.ec2_target_id
    port             = var.app_port
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http" {
    count             = var.is_ssl == true ? 0 : 1
    load_balancer_arn = aws_alb.main.id
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.app.id
    }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http_redirect" {
    count             = var.is_ssl == true ? 1 : 0
    load_balancer_arn = aws_alb.main.id
    port              = 80
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

resource "aws_alb_listener" "https" {
    count             = var.is_ssl == true ? 1 : 0
    load_balancer_arn = aws_alb.main.id
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.certificate_arn_attach_alb_listener
    default_action {
        target_group_arn = aws_alb_target_group.app.id
        type             = "forward"
    }
}