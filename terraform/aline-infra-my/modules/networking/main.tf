resource "aws_vpc" "aline_vpc_my"{
    cidr_block = var.vpc_block # "172.3.0.0/16" # vpc-block
    tags = {
      "name" = "aline_vpc_my"
    }
}

resource "aws_internet_gateway" "aline_igw_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    tags = {
        "name" = "aline_igw_my"
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
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_subnet" "aline_public_sub_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = var.public_block # "172.3.1.0/24" # public-block
    map_public_ip_on_launch = true
    tags = {
        "name" = "aline_public_sub_my"
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
        "name" = "aline_route_table_public_my"
    }
}

resource "aws_route_table_association" "aline_public_associate_my"{
    subnet_id = aws_subnet.aline_public_sub_my.id
    route_table_id = aws_route_table.aline_route_table_public_my.id
}

resource "aws_eip" "aline_eip_my"{
    vpc = true
    tags = {
        "name" = "aline_eip_my"
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
        "name" = "aline_private_sub_my"
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
        "name" = "aline_route_table_private_my"
    }
}

resource "aws_route_table_association" "aline_private_associate_my"{
    subnet_id = aws_subnet.aline_private_sub_my.id
    route_table_id = aws_route_table.aline_route_table_private_my.id
}
