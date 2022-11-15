resource "aws_security_group" "siva-alb-sg" {
  name        = "alb-sg"
  description = "this is using for securitygroup"
  vpc_id      = "vpc-0b8a10a9f3969a588"

#   ingress {
#     description = "this is inbound rule"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["103.110.170.84/32"]
#   }
  ingress {
    description = "this is inbound rule"
    from_port   = 80
    to_port     = 80
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mahesh-alb-sg"
  }
}


resource "aws_lb" "siva-test-alb" {
  name               = "mahesh-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.siva-alb-sg.id]
  subnets            = ["subnet-0f957a91835d9febe","subnet-0b4c5d675ba3aaa76"]

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "mahesh-alb"
  }
}

resource "aws_lb_target_group" "siva-tg-jenkins" {
  name     = "tg-jenkins"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0b8a10a9f3969a588"
}

resource "aws_lb_target_group_attachment" "siva-tg-attachment-jenkins" {
  target_group_arn = aws_lb_target_group.siva-tg-jenkins.arn
  target_id        = aws_instance.cicd.id
  port             = 8080
}


resource "aws_lb_target_group" "siva-tg-tomcat" {
  name     = "tg-tomcat"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0b8a10a9f3969a588"
}

resource "aws_lb_target_group_attachment" "siva-tg-attachment-tomcat" {
  target_group_arn = aws_lb_target_group.siva-tg-tomcat.arn
  target_id        = aws_instance.tomcat.id
  port             = 8080
}


resource "aws_lb_listener" "siva-alb-listener" {
  load_balancer_arn = aws_lb.siva-test-alb.arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.siva-tg-jenkins.arn
  }
}

resource "aws_lb_listener_rule" "siva-jenkins-hostbased" {
  listener_arn = aws_lb_listener.siva-alb-listener.arn
#   priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.siva-tg-jenkins.arn
  }

  condition {
    host_header {
      values = ["jenkins.siva.quest"]
    }
  }
}

resource "aws_lb_listener_rule" "siva-tomcat-hostbased" {
  listener_arn = aws_lb_listener.siva-alb-listener.arn
#   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.siva-tg-tomcat.arn
  }

  condition {
    host_header {
      values = ["tomcat.siva.quest"]
    }
  }
}