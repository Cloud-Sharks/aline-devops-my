resource "aws_instance" "aline_test_public_my"{
    ami = var.ami_code
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = data.public_subnet
}