variable "vpc_block"{
    type = string
    description = "CIDR block for VPC"
}

variable "external_ingress_rules"{
    type = map
    description = "Ingress rules for external communication"
}

variable "avail_zone1"{
    type = string
    description = "First availability zone"
}

variable "avail_zone2"{
    type = string
    description = "Second availability zone"
}

variable "public_block1"{
    type = string
    description = "CIDR block for public subnet 1"
}

variable "public_block2"{
    type = string
    description = "CIDR block for public subnet 2"
}

variable "private_block1"{
    type = string
    description = "CIDR block for private subnet 1"
}

variable "private_block2"{
    type = string
    description = "CIDR block for private subnet 2"
}

variable "ami_id"{
    type = string
    description = "AMI ID for the bastion"
}

variable "ssh_key_name"{
    type = string
    description = "Name of the ssh key for the bastion"
}

variable "db_vpc_id"{
    type = string
    description = "ID of the subnet with the remote database"
}
