resource "aws_security_group" "pavan" {
  name        = "cicd"
  description = "this is using for securitygroup"
  vpc_id      = "vpc-0b8a10a9f3969a588"

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # security_groups = ["${aws_security_group.pavan-bastion.id}"]
    cidr_blocks = ["103.110.170.85/32"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 8080
    to_port     = 8080
    protocol    = "all"
    # security_groups = ["${aws_security_group.siva-alb-sg.id}"]
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
    Name = "siva"
  }
}
resource "aws_instance" "cicd" {
  ami                    = "ami-0d593311db5abb72b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0bda738cf539ec7ca"
  vpc_security_group_ids = [aws_security_group.pavan.id]
  key_name               =aws_key_pair.demo.id
  # iam_instance_profile = aws_iam_instance_profile.cicd-iam.name
  user_data              = <<EOF
             #!/bin/bash
             wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
 rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
 yum update -y
 amazon-linux-extras install java-openjdk11
 yum install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins
       EOF
  tags = {
    Name = "stage-cicd"
  }
}
# tags = {
#   Name = "pk-bastion-sg"
# }
