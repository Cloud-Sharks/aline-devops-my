resource "aws_instance" "aline_test_public_my"{
    ami = var.ami_code_public
    instance_type = var.instance_type_public
    # key_name = var.key_name_public
    # subnet_id = data.public_subnet
    subnet_id = var.public_subnet
    # vpc_security_group_ids = data.public_sg_my
    vpc_security_group_ids = [var.external_sg_my, var.internal_sg_my]
    tags = {
        Name = "aline_test_public_my"
    }
}

resource "aws_instance" "aline_test_private_my"{
    ami = var.ami_code_private
    instance_type = var.instance_type_private
    # key_name = var.key_name_private
    # subnet_id = data.private_subnet
    subnet_id = var.private_subnet
    # vpc_security_group_ids = data.private_sg_my
    vpc_security_group_ids = [var.internal_sg_my]
    tags = {
        Name = "aline_test_private_my"
    }
}