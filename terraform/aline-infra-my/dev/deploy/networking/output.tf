output "vpc_name"{
    value = module.networking.vpc_name
}

output "gateway_name"{
    value = module.networking.gateway_name
}

output "peering_name"{
    value = module.networking.peering_name
}

output "bastion_info"{
    value = module.networking.bastion_info
}