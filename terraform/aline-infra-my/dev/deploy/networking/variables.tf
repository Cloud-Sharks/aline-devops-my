variable "vpc_block"{
    type = string
    description = "CIDR block for VPC"
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

variable "db_vpc_id"{
    type = string
    description = "ID of the subnet with the remote database"
}

variable "s3_bucket"{
    type = string
    description = "S3 bucket of the project"
}

variable "s3_key"{
    type = string
    description = "S3 key of the project"
}

variable "aws_region"{
    type = string
    description = "AWS Region of the project"
}
