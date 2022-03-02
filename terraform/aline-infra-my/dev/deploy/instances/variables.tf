variable "ami_code_public"{
    type = string
    description = "AMI code for public ec2 instance"
}

variable "instance_type_public"{
    type = string
    description = "Type of public ec2 instance"
}

# variable "key_name_public"{
#     type = string
#     description = "Name of public ssh key pair"
# }

variable "public_subnet"{
    type = string
    description = "ID of public subnet"
}

variable "external_sg_my"{
    type = string
    description = "Name of security group for external communication"
}

variable "ami_code_private"{
    type = string
    description = "AMI code for private ec2 instance"
}

variable "instance_type_private"{
    type = string
    description = "Type of private ec2 instance"
}

# variable "key_name_private"{
#     type = string
#     description = "Name of private ssh key pair"
# }

variable "private_subnet"{
    type = string
    description = "ID of private subnet"
}

variable "internal_sg_my"{
    type = string
    description = "Name of security group for internal communication"
}
