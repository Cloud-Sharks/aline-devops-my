output "vpc_name"{
    value = module.networking.vpc_name
}

output "vpc_id"{
    value = module.networking.vpc_id
}

output "gateway_name"{
    value = module.networking.gateway_name
}

output "peering_name"{
    value = module.networking.peering_name
}

output "bastion_ip"{
    value = module.networking.bastion_ip
}