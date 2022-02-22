output "aws_vpc"{
    value = module.networking.aws_vpc
}

output "aws_internet_gateway"{
    value = module.networking.aws_internet_gateway
}

output "aws_nat_gateway"{
    value = module.networking.aws_nat_gateway
}

output "aws_subnet"{
    value = module.networking.aws_subnet
}

# output "aws_subnet_public"{
#     value = module.networking.aline_public_sub_my
# }

# output "aws_subnet_private"{
#     value = module.networking.aline_private_sub_my
# }