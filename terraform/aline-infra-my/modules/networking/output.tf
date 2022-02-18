output "aws_vpc"{
    description = "The created VPC"
    value = aws_vpc.aline_vpc_my
}

output "aws_internet_gateway"{
    description = "The created IGW"
    value = aws_internet_gateway.aline_igw_my
}

output "aws_nat_gateway"{
    description = "The created NAT GW"
    value = aws_nat_gateway.aline_nat_gw_my
}
