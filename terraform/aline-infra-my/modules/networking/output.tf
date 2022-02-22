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

output "aws_subnet"{
    description = "The created subnets"
    value = aws_subnet.aline_public_sub_my
}

# output "aws_subnet_public"{
#     description = "The created public subnet"
#     value = aws_subnet.aline_public_sub_my
# }

# output "aws_subnet_private"{
#     description = "The created private subnet"
#     value = aws_subnet.aline_private_sub_my
# }