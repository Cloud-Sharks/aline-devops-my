output "vpc_name"{
    value = aws_vpc.aline_vpc_my_dev.tags["Name"]
    description = "The name of the VPC"
}

output "gateway_name"{
    value = aws_internet_gateway.aline_igw_my_dev.tags["Name"]
    description = "The name of the Internet Gateway"
}

output "peering_name"{
    value = aws_vpc_peering_connection.aline_peering_my_dev.tags["Name"]
    description = "The name of the Peering Connection"
}

output "bastion_info"{
    value = aws_instance.aline_bastion_my_dev.public_dns
    description = "Information about the Bastion"
}