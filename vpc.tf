# Configure VPC

resource "aws_vpc" "main"{
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"

    tags = {
        name = "main"
    }
}

# Configure public subnet

resource "aws_subnet" "main-public-1"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"

    tags = {
        name = "main-public-1"
    }
}

resource "aws_subnet" "main-public-2"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"

    tags = {
        name = "main-public-2"
    }
}

# Configure private subnet

resource "aws_subnet" "main-private_1"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "ap-south-1a"

    tags = {
        name = "main-private_1"
    }
}

resource "aws_subnet" "main-private_2"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "ap-south-1b"

    tags = {
        name = "main-private_2"
    }
}

# Configure Internet Gateway

resource "aws_internet_gateway" "main-gw"{
    vpc_id = aws_vpc.main.id

    tags = {
        name = "main"
    }
}

# Configure Route Table

resource "aws_route_table" "main-public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-gw.id
    }

    tags = {
        Name = "main-public-1"
    }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.main-public.id
}
resource "aws_route_table_association" "main-public-2-a" {
    subnet_id = aws_subnet.main-public-2.id
    route_table_id = aws_route_table.main-public.id
}
