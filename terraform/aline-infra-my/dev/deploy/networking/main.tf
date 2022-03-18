module "networking"{
    source = "../../modules/networking"
    vpc_block = var.vpc_block
    external_ingress_rules = var.external_ingress_rules
    avail_zone1 = var.avail_zone1
    avail_zone2 = var.avail_zone2
    public_block1 = var.public_block1
    private_block1 = var.private_block1
    public_block2 = var.public_block2
    private_block2 = var.private_block2
    db_vpc_id = var.db_vpc_id
}