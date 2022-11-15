resource "aws_security_group" "pavan-bastion" {
  name        = "bastion"
  description = "this is using for securitygroup"
  vpc_id      = "vpc-0b8a10a9f3969a588"

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.110.170.84/32"]
  }
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
    Name = "siva"
  }
}
resource "aws_instance" "bastion" {
  ami                    = "ami-0d593311db5abb72b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0b4c5d675ba3aaa76"
  vpc_security_group_ids = [aws_security_group.pavan-bastion.id]
  key_name               =aws_key_pair.demo.id
  # iam_instance_profile = aws_iam_instance_profile.cicd-iam.name
#   user_data              = <<EOF
#              #!/bin/bash
#              wget -O /etc/yum.repos.d/jenkins.repo \
#     https://pkg.jenkins.io/redhat-stable/jenkins.repo
#  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#  yum update -y
#  amazon-linux-extras install java-openjdk11
#  yum install jenkins -y
#  systemctl start jenkins
#  systemctl enable jenkins
#        EOF
  tags = {
    Name = "stage-bastion"
  }
}
# tags = {
#   Name = "pk-bastion-sg"
# }
