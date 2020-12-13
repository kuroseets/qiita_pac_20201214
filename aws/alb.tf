resource "aws_alb" "alb" {
  name                       = format("%s-%s-alb", var.application_name, var.environment)
  security_groups            = [aws_security_group.alb.id]
  subnets                    = aws_subnet.public_subnet.*.id
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket = aws_s3_bucket.log_bucket.bucket
  }
}

resource "aws_alb_target_group" "alb-target-group" {
  name     = format("%s-%s-alb-tg", var.application_name, var.environment)
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_target_group_attachment" "alb-target-group-attachment" {
  count            = length(aws_instance.web_servers)
  target_group_arn = aws_alb_target_group.alb-target-group.arn
  target_id        = aws_instance.web_servers[count.index].id
  port             = 80
}
