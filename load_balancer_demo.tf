provider "aws" {
  region = "eu-west-1"
}

resource "aws_security_group" "instance_security_group" {
  name        = "instance_security_group"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "instance_subnet" {
  vpc_id     = aws_vpc.instance_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "instance_subnet"
  }
}

resource "aws_instance" "instance" {
  ami           = "ami-0b752bf1df193a6c4"
  instance_type = "t2.micro"
  count         = 2

  subnet_id = aws_subnet.instance_subnet.id
  security_groups = [
    aws_security_group.instance_security_group.name
  ]

  user_data = "${file("user_data.sh")}"

  tags = {
    Name = "instance-${count.index}"
  }
}

resource "aws_elb" "instance_elb" {
  name               = "instance-elb"
  availability_zones = ["eu-west-1a", "eu-west-1b"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/health"
    interval            = 30
  }

  instances = [aws_instance.instance.*.id]
}