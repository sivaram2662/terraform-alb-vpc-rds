resource "aws_security_group" "tomcat-sg" {
  name        = "tomcat"
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
    Name = "tomcat-sg"
  }
}
resource "aws_instance" "tomcat" {
  ami                    = "ami-0d593311db5abb72b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0bda738cf539ec7ca"
  # count                  = 2
  vpc_security_group_ids = [aws_security_group.tomcat-sg.id]
  key_name               = aws_key_pair.demo.id
  #   iam_instance_profile = aws_iam_instance_profile.cicd-iam.name
  user_data = <<EOF
             #!/bin/bash

 yum -y update
 amazon-linux-extras install java-openjdk11 -y
 java -version
 cd /opt
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
tar  apache-tomcat-9.0.65.tar.gz
tar -xzvf  apache-tomcat-9.0.65.tar.gz
chmod -R 755 apache-tomcat-9.0.65.tar.gz
rm -rf  apache-tomcat-9.0.65.tar.gz
mv apache-tomcat-9.0.65 tomcat9
cd tomcat9/
cd bin
sh startup.sh
wget https://www.oracle.com/webfolder/technetwork/tutorials/obe/fmw/wls/10g/r3/cluster/session_state/files/shoppingcart.zip
unzip shoppingcart.zip
cp shoppingcart.war ../webapps/
       EOF
  tags = {
    Name = "stage-tomcat"
  }
}
# tags = {
#   Name = "pk-bastion-sg"
# }
