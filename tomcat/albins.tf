# #creating target group 
#  resource "aws_lb_target_group" "target-group" {
# #   health_check {
# #     interval            = 10
# #     path                = "/"
# #     protocol            = "HTTP"
# #     timeout             = 5
# #     healthy_threshold   = 5
# #     unhealthy_threshold = 2
# #   }
#   name        = "alb-tg"
#   target_type = "instance"
#   port        = 8080
#   protocol    = "HTTP"
#   vpc_id      = "vpc-0b8a10a9f3969a588"
# }
# #creating alb # aws alb 
# resource "aws_lb" "application-lb" {
#   name               = "whiz-alb"
#   internal           = false
#   ip_address_type    = "ipv4"
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.tomcat-sg.id]
#   subnets            = ["subnet-0b4c5d675ba3aaa76", "subnet-0f957a91835d9febe"]

#   tags = {
#     name = "whiz-alb"
#   }
# }
# #creating listener
# resource "aws_lb_listener" "alb-listener" {
#   load_balancer_arn = aws_lb.application-lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target-group.arn
#   }
# }
# #attachment
# resource "aws_lb_target_group_attachment" "ec2-attach" {
#   count            = length(aws_instance.tomcat)
#   target_group_arn = aws_lb_target_group.target-group.arn
#   target_id        = aws_instance.tomcat[count.index].id
# }