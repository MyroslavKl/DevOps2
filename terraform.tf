provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "example_sg" {
  name        = "example_sg"
  description = "Example security group"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "example_instance1" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "example_key" 
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo docker run -d -p 9090:9090 --name prometheus prom/prometheus
    sudo docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter
    sudo docker run -d --net="host" --pid="host" -v "/:/rootfs:ro" -v "/var/run:/var/run:ro" -v "/sys:/sys:ro" -v "/var/lib/docker/:/var/lib/docker:ro" -v "/dev/disk/:/dev/disk:ro" -p 8080:8080 quay.io/prometheus/cadvisor
    EOF
}

resource "aws_instance" "example_instance2" {
  ami           = "ami-0c94855ba95c71c99" 
  instance_type = "t2.micro"
  key_name      = "example_key" 
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter
    sudo docker run -d --net="host" --pid="host" -v "/:/rootfs:ro" -v "/var/run:/var/run:ro" -v "/sys:/sys:ro" -v "/var/lib/docker/:/var/lib/docker:ro" -v "/dev/disk/:/dev/disk:ro" -p 8080:8080 quay.io/prometheus/cadvisor
    EOF
}