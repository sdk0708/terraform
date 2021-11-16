resource "aws_lb" "tf_alb" {
 name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = var.load_type
  security_groups    = [aws_security_group.tf_sg.id]
  subnets            = [aws_subnet.tf_pub[0].id, aws_subnet.tf_pub[1].id] # loadbalancer가 사용할 public zone

  tags = {
    "Name" = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "tf_albtg" {
  name     = "${var.name}-albtg"
  port     = var.port_http
  protocol = var.protocol_http1
  target_type = "instance"
  vpc_id   = aws_vpc.tf_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = var.protocol_http1
    timeout             = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "tf_albli" {
  load_balancer_arn = aws_lb.tf_alb.arn
  port              = var.port_http
  protocol          = var.protocol_http1

default_action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.tf_albtg.arn
  }
}

resource "aws_lb_target_group_attachment" "tf_tgatt" {
  target_group_arn = aws_lb_target_group.tf_albtg.arn
  target_id        = aws_instance.tf_web.id
  port             = var.port_http
}