resource "aws_vpc" "aline_vpc_my"{
    cidr_block = var.vpc_block # "172.3.0.0/16" # vpc-block
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
    name = "allow_http_tls"
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
        Name = "allow_http_tls"
    }
}

resource "aws_security_group" "aline_subnet_communication_my"{
    name = "allow_subnet_comm"
    description = "Allow public and private subnets communicate with each other"
    vpc_id = aws_vpc.aline_vpc_my.id
    ingress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = [var.public_block]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = [var.private_block]
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

resource "aws_subnet" "aline_public_sub_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.public_block # "172.3.1.0/24" # public-block
    map_public_ip_on_launch = true
    tags = {
        Name = "aline_public_sub_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_route_table" "aline_route_table_public_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    route{
        cidr_block = "0.0.0.0/0" # public-table-block
        gateway_id = aws_internet_gateway.aline_igw_my.id
    }
    tags = {
        Name = "aline_route_table_public_my"
    }
}

resource "aws_route_table_association" "aline_public_associate_my"{
    subnet_id = aws_subnet.aline_public_sub_my.id
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
    subnet_id = aws_subnet.aline_public_sub_my.id
}

resource "aws_subnet" "aline_private_sub_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.private_block # "172.3.2.0/24" # private-block
    map_public_ip_on_launch = false
    tags = {
        Name = "aline_private_sub_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_route_table" "aline_route_table_private_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    route{
        cidr_block = "0.0.0.0/0" # private-table-block
        nat_gateway_id = aws_nat_gateway.aline_nat_gw_my.id
    }
    tags = {
        Name = "aline_route_table_private_my"
    }
}

resource "aws_route_table_association" "aline_private_associate_my"{
    subnet_id = aws_subnet.aline_private_sub_my.id
    route_table_id = aws_route_table.aline_route_table_private_my.id
}
