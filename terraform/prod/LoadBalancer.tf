
resource "aws_elb" "httplb" {
  name       = "httplb"
  security_groups    = [aws_security_group.sg_allow_web.id]
  subnets            = aws_subnet.public.*.id
  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }

  listener {
    lb_port = 8080
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }

  tags = {
    Name = "AndProdBal"
  }

}

