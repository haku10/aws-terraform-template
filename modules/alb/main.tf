resource "aws_lb" "alb_backend" {
  name                       = "${var.system}-${var.env}-alb-backend"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false #LBの削除保護
  idle_timeout               = 60
}

resource "aws_lb_target_group" "target_group_backend" {
  name = "${var.system}-${var.env}-tg-backend"
  # ドメインが割り当てられるまでの一時対応
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/healthcheck"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}


# TODO: 後でコメントアウトを外す

# resource "aws_lb_listener_rule" "ecs_listener_role_backend" {
#   listener_arn = aws_lb_listener.listener_backend.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group_backend.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#     # TODO ALBのアクセスを制限する際に有効化する
#     # http_header {
#     #   http_header_name = "x-origin-key"
#     #   values = [
#     #     jsondecode(data.aws_secretsmanager_secret_version.x_origin_key.secret_string)["X_ORIGIN_KEY"]
#     #   ]
#     # }
#   }
# }

# resource "aws_lb_listener" "listener_backend" {
#   # HTTPSでのアクセスを受け付ける
#   port            = "443"
#   protocol        = "HTTPS"
#   certificate_arn = data.aws_acm_certificate.web_admin_backend.arn

#   load_balancer_arn = aws_lb.alb_backend.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group_backend.arn
#   }
# }


resource "aws_lb" "alb_frontend" {
  name                       = "${var.system}-${var.env}-alb-frontend"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false #LBの削除保護
  idle_timeout               = 60
}

resource "aws_lb_target_group" "target_group_frontend" {
  name = "${var.system}-${var.env}-tg-frontend"
  # ドメインが割り当てられるまでの一時対応
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener_rule" "ecs_listener_role_frontend" {
  listener_arn = aws_lb_listener.listener_frontend.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_frontend.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
    # TODO ALBのアクセスを制限する際に有効化する
    # http_header {
    #   http_header_name = "x-origin-key"
    #   values = [
    #     jsondecode(data.aws_secretsmanager_secret_version.x_origin_key.secret_string)["X_ORIGIN_KEY"]
    #   ]
    # }
  }
}

resource "aws_lb_listener" "listener_frontend" {
  # HTTPSでのアクセスを受け付ける
  port            = "443"
  protocol        = "HTTPS"
  certificate_arn = data.aws_acm_certificate.web_admin_frontend.arn

  load_balancer_arn = aws_lb.alb_frontend.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_frontend.arn
  }
}

# 管理画面ALBで利用するACM
data "aws_acm_certificate" "web_admin_backend" {
  domain = var.backend_dns_name
}

# 管理画面ALBで利用するACM
data "aws_acm_certificate" "web_admin_frontend" {
  domain = var.frontend_dns_name
}

resource "aws_lb" "alb_backend_of_participant" {
  name                       = "${var.system}-${var.env}-alb-backend-of-pp"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false #LBの削除保護
  idle_timeout               = 60
}

resource "aws_lb_target_group" "target_group_backend_of_participant" {
  name = "${var.system}-${var.env}-tg-backend-of-pp"
  # ドメインが割り当てられるまでの一時対応
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/healthcheck"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener_rule" "ecs_listener_role_backend_of_participant" {
  listener_arn = aws_lb_listener.listener_backend_of_participant.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_backend_of_participant.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
    # TODO ALBのアクセスを制限する際に有効化する
    # http_header {
    #   http_header_name = "x-origin-key"
    #   values = [
    #     jsondecode(data.aws_secretsmanager_secret_version.x_origin_key.secret_string)["X_ORIGIN_KEY"]
    #   ]
    # }
  }
}


resource "aws_lb" "alb_frontend_of_participant" {
  name                       = "${var.system}-${var.env}-alb-frontend-of-pp"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.sg_id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false #LBの削除保護
  idle_timeout               = 60
}

resource "aws_lb_target_group" "target_group_frontend_of_participant" {
  name = "${var.system}-${var.env}-tg-frontend-of-pp"
  # ドメインが割り当てられるまでの一時対応
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener_rule" "ecs_listener_role_frontend_of_participant" {
  listener_arn = aws_lb_listener.listener_frontend_of_participant.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_frontend_of_participant.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
    # TODO ALBのアクセスを制限する際に有効化する
    # http_header {
    #   http_header_name = "x-origin-key"
    #   values = [
    #     jsondecode(data.aws_secretsmanager_secret_version.x_origin_key.secret_string)["X_ORIGIN_KEY"]
    #   ]
    # }
  }
}

resource "aws_lb_listener" "listener_frontend_of_participant" {
  # HTTPSでのアクセスを受け付ける
  port            = "443"
  protocol        = "HTTPS"
  certificate_arn = data.aws_acm_certificate.web_admin_frontend_of_participant.arn

  load_balancer_arn = aws_lb.alb_frontend_of_participant.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_frontend_of_participant.arn
  }
}
