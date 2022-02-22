variable "vpc_block"{
    type = string
    description = "CIDR block for VPC"
}

variable "public_block"{
    type = string
    description = "CIDR block for public subnet"
}

variable "private_block"{
    type = string
    description = "CIDR block for private subnet"
}
