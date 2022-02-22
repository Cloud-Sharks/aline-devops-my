module "networking"{
    source = "./modules/networking"
    vpc_block = var.vpc_block
    public_block = var.public_block
    private_block = var.private_block
}