output "aws_vpc"{
    value = module.networking.aws_vpc
}

output "aws_internet_gateway"{
    value = module.networking.aws_internet_gateway
}

output "aws_nat_gateway"{
    value = module.networking.aws_nat_gateway
}
