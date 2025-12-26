#Creating VPC
resource "aws_vpc"  "my_vpc" {
  cidr_block = var.cidr
}


#Creating Subnet-1
resource "aws_subnet" "Subnet-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}


#Creating Subnet-2
resource "aws_subnet" "Subnet-2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}


#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}


#Creating Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


#Associating Subnets with Route Table
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.Subnet-1.id
  route_table_id = aws_route_table.RT.id
}


resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.Subnet-2.id
  route_table_id = aws_route_table.RT.id
}


# Security Group
resource "aws_security_group" "webSG" {
  name   = "web-sg"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "web-sg"
  }
}

# HTTP Ingress (Port 80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.webSG.id
  description = "HTTP from VPC"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

# SSH Ingress (Port 22)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.webSG.id
  cidr_ipv4         = "103.135.63.219/32"
  description       = "SSH from VPC"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Egress - Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.webSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#making S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "shubhamgupta6390337658"
}


#Creating EC2 Instance
resource "aws_instance" "webServer1" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id              = aws_subnet.Subnet-1.id
  user_data              = file("userdata.sh")
}

resource "aws_instance" "webServer2" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id              = aws_subnet.Subnet-2.id
  user_data              = file("userdata1.sh")
}

#create ALB
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webSG.id]
  subnets            = [aws_subnet.Subnet-1.id, aws_subnet.Subnet-2.id]


}


#Creating Target Group
resource "aws_lb_target_group" "tg" {
  name     = "my-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

#Attaching EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webServer1.id
  port             = 80
}

#Attaching EC2 Instances to Target Group
resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webServer2.id
  port             = 80
}

#Creating Listener for ALB on Port 80 expecting HTTP traffic
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"

  }

}

#Output the DNS name of the Load Balancer on CLI only 
output "load_balancer_dns" {
  value = aws_lb.myalb.dns_name
}


