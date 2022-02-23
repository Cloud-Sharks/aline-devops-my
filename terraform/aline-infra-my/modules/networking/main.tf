resource "aws_vpc" "aline_vpc_my"{
    cidr_block = var.vpc_block
    tags = {
      Name = "aline_vpc_my"
    }
}

resource "aws_internet_gateway" "aline_igw_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    tags = {
        Name = "aline_igw_my"
    }
}

resource "aws_security_group" "allow_ssh_http_tls"{
    name = "allow_ssh_http_tls"
    description = "Allow inbound traffic from ssh, http, and TLS"
    vpc_id = aws_vpc.aline_vpc_my.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_ssh_http_tls"
    }
}

resource "aws_security_group" "aline_subnet_communication_my"{
    name = "allow_subnet_comm"
    description = "Allow public and private subnets communicate with each other"
    vpc_id = aws_vpc.aline_vpc_my.id
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.public_block1, var.public_block2]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.private_block1, var.private_block2]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_subnet_comm"
    }
}

resource "aws_route_table" "aline_route_table_public_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aline_igw_my.id
    }
    tags = {
        Name = "aline_route_table_public_my"
    }
}

resource "aws_subnet" "aline_public_sub1_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.public_block1
    availability_zone = var.avail_zone1
    map_public_ip_on_launch = true
    tags = {
        Name = "aline_public_sub1_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_subnet" "aline_public_sub2_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.public_block2
    availability_zone = var.avail_zone2
    map_public_ip_on_launch = true
    tags = {
        Name = "aline_public_sub2_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_route_table_association" "aline_public1_associate_my"{
    subnet_id = aws_subnet.aline_public_sub1_my.id
    route_table_id = aws_route_table.aline_route_table_public_my.id
}

resource "aws_route_table_association" "aline_public2_associate_my"{
    subnet_id = aws_subnet.aline_public_sub2_my.id
    route_table_id = aws_route_table.aline_route_table_public_my.id
}

resource "aws_eip" "aline_eip_my"{
    vpc = true
    tags = {
        Name = "aline_eip_my"
    }
    depends_on = [aws_internet_gateway.aline_igw_my]
}

resource "aws_nat_gateway" "aline_nat_gw_my"{
    allocation_id = aws_eip.aline_eip_my.id
    subnet_id = aws_subnet.aline_public_sub1_my.id
    tags = {
        Name = "aline_nat_gw_my"
    }
}

resource "aws_route_table" "aline_route_table_private_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.aline_nat_gw_my.id
    }
    tags = {
        Name = "aline_route_table_private_my"
    }
}

resource "aws_subnet" "aline_private_sub1_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.private_block1
    availability_zone = var.avail_zone1
    map_public_ip_on_launch = false
    tags = {
        Name = "aline_private_sub1_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_subnet" "aline_private_sub2_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.private_block2
    availability_zone = var.avail_zone2
    map_public_ip_on_launch = false
    tags = {
        Name = "aline_private_sub2_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_route_table_association" "aline_private1_associate_my"{
    subnet_id = aws_subnet.aline_private_sub1_my.id
    route_table_id = aws_route_table.aline_route_table_private_my.id
}

resource "aws_route_table_association" "aline_private2_associate_my"{
    subnet_id = aws_subnet.aline_private_sub2_my.id
    route_table_id = aws_route_table.aline_route_table_private_my.id
}
