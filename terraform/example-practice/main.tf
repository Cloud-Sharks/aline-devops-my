resource "aws_vpc" "my_vpc" {
  cidr_block = "172.17.0.0/16"
  tags = {
    Name = "TestTerraform"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id     = aws_vpc.my_vpc.id
  depends_on = [aws_vpc.my_vpc]
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
  depends_on = [aws_vpc.my_vpc]
}


resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "TestRouteTable"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.17.10.0/24"

  tags = {
    Name = "TestSubnet"
  }
  depends_on = [aws_vpc.my_vpc]
}

resource "aws_main_route_table_association" "vpc_association" {
  vpc_id         = aws_vpc.my_vpc.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_network_interface" "foo" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["172.17.10.100"]
  security_groups = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
  key_name      = "terraform"
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
  tags = {
    Name = "TestInstance"
  }
}

resource "aws_eip" "lb" {
  instance                  = aws_instance.foo.id
  associate_with_private_ip = "172.17.10.100"
  vpc                       = true
}

resource "null_resource" "testconnection" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./terraform.pem")
    host        = aws_eip.lb.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo test > test_file.txt"
    ]
  }
}