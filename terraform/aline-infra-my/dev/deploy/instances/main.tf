module "instances"{
    source = "../../modules/instances"
    ami_code_public = var.ami_code_public
    instance_type_public = var.instance_type_public
    # key_name_public = var.key_name_public
    public_subnet = var.public_subnet
    external_sg_my = var.external_sg_my
    ami_code_private = var.ami_code_private
    instance_type_private = var.instance_type_private
    # key_name_private = var.key_name_private
    private_subnet = var.private_subnet
    internal_sg_my = var.internal_sg_my
}