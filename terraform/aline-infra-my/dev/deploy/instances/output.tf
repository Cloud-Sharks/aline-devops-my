output "aws_instance"{
    description = "The created instance in the public subnet"
    value = module.instances.aws_instance
}

