resource "aws_vpc" "aline_vpc_my_dev"{
    cidr_block = var.vpc_block
    tags = {
      Name = "aline_vpc_my_dev"
    }
}

resource "aws_internet_gateway" "aline_igw_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    tags = {
        Name = "aline_igw_my_dev"
    }
}

resource "aws_security_group" "allow_ssh_http_tls"{
    name = "allow_ssh_http_tls"
    description = "Allow inbound traffic from ssh, http, and TLS"
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_ssh_http_tls"
    }
}

resource "aws_security_group" "aline_subnet_communication_my"{
    name = "allow_subnet_comm"
    description = "Allow public and private subnets communicate with each other"
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.public_block1, var.public_block2]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.private_block1, var.private_block2]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_subnet_comm"
    }
}

resource "aws_route_table" "aline_route_table_public_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aline_igw_my_dev.id
    }
    tags = {
        Name = "aline_route_table_public_my_dev"
    }
}

resource "aws_subnet" "aline_public_sub1_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    cidr_block = var.public_block1
    availability_zone = var.avail_zone1
    map_public_ip_on_launch = true
    tags = {
        Name = "aline_public_sub1_my_dev"
        "kubernetes.io/cluster/aline-eks-my" = "owned"
        "kubernetes.io/role/elb" = "1"
    }
    depends_on = [aws_vpc.aline_vpc_my_dev]
}

resource "aws_subnet" "aline_public_sub2_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    cidr_block = var.public_block2
    availability_zone = var.avail_zone2
    map_public_ip_on_launch = true
    tags = {
        Name = "aline_public_sub2_my_dev"
        "kubernetes.io/cluster/aline-eks-my" = "owned"
        "kubernetes.io/role/elb" = "1"
    }
    depends_on = [aws_vpc.aline_vpc_my_dev]
}

resource "aws_route_table_association" "aline_public1_associate_my_dev"{
    subnet_id = aws_subnet.aline_public_sub1_my_dev.id
    route_table_id = aws_route_table.aline_route_table_public_my_dev.id
}

resource "aws_route_table_association" "aline_public2_associate_my_dev"{
    subnet_id = aws_subnet.aline_public_sub2_my_dev.id
    route_table_id = aws_route_table.aline_route_table_public_my_dev.id
}

resource "aws_eip" "aline_eip_my_dev"{
    vpc = true
    tags = {
        Name = "aline_eip_my_dev"
    }
    depends_on = [aws_internet_gateway.aline_igw_my_dev]
}

resource "aws_nat_gateway" "aline_nat_gw_my_dev"{
    allocation_id = aws_eip.aline_eip_my_dev.id
    subnet_id = aws_subnet.aline_public_sub1_my_dev.id
    tags = {
        Name = "aline_nat_gw_my_dev"
    }
}

resource "aws_route_table" "aline_route_table_private_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.aline_nat_gw_my_dev.id
    }
    tags = {
        Name = "aline_route_table_private_my_dev"
    }
}

resource "aws_subnet" "aline_private_sub1_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    cidr_block = var.private_block1
    availability_zone = var.avail_zone1
    map_public_ip_on_launch = false
    tags = {
        Name = "aline_private_sub1_my_dev"
        "kubernetes.io/cluster/aline-eks-my" = "owned"
        "kubernetes.io/role/internal-elb" = "1"
    }
    depends_on = [aws_vpc.aline_vpc_my_dev]
}

resource "aws_subnet" "aline_private_sub2_my_dev"{
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    cidr_block = var.private_block2
    availability_zone = var.avail_zone2
    map_public_ip_on_launch = false
    tags = {
        Name = "aline_private_sub2_my_dev"
        "kubernetes.io/cluster/aline-eks-my" = "owned"
        "kubernetes.io/role/internal-elb" = "1"
    }
    depends_on = [aws_vpc.aline_vpc_my_dev]
}

resource "aws_route_table_association" "aline_private1_associate_my_dev"{
    subnet_id = aws_subnet.aline_private_sub1_my_dev.id
    route_table_id = aws_route_table.aline_route_table_private_my_dev.id
}

resource "aws_route_table_association" "aline_private2_associate_my_dev"{
    subnet_id = aws_subnet.aline_private_sub2_my_dev.id
    route_table_id = aws_route_table.aline_route_table_private_my_dev.id
}

// establish peering connection
resource "aws_vpc_peering_connection" "aline_peering_my_dev"{
    peer_vpc_id = var.db_vpc_id
    vpc_id = aws_vpc.aline_vpc_my_dev.id
    auto_accept = true
}

// Store necessary info for EKS cluster as secrets
resource "aws_secretsmanager_secret" "aline_vpc_secrets_my_dev"{
    name = "aline_vpc_secrets_my_dev"
    force_overwrite_replica_secret = true
    recovery_window_in_days = 0
}

locals{
    vpc_secrets = {
        vpc_id = aws_vpc.aline_vpc_my_dev.id
        public1_id = aws_subnet.aline_public_sub1_my_dev.id
        public2_id = aws_subnet.aline_public_sub2_my_dev.id
        private1_id = aws_subnet.aline_private_sub1_my_dev.id
        private2_id = aws_subnet.aline_private_sub2_my_dev.id
    }
}

resource "aws_secretsmanager_secret_version" "aline_vpc_secrets_my_dev"{
    secret_id = aws_secretsmanager_secret.aline_vpc_secrets_my_dev.id
    secret_string = jsonencode(local.vpc_secrets)
}
