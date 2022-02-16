resource "aws_vpc" "aline_vpc_my" {
    cidr_block = "172.3.0.0/16"
    tags = {
      "name" = "aline_vpc_my"
    }
}

resource "aws_subnet" "aline_public_sub_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = "172.3.0.1/24"
    map_public_ip_on_launch = true
    tags = {
        "name" = "aline_public_sub_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}

resource "aws_subnet" "aline_private_sub_my"{
    vpc_id = aws_vpc.aline_vpc_my.id
    cidr_block = "172.3.0.2/24"
    map_public_ip_on_launch = false
    tags = {
        "name" = "aline_private_sub_my"
    }
    depends_on = [aws_vpc.aline_vpc_my]
}