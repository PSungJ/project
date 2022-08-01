resource"aws_route_table" "igw_route" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = var.cidr.igwrt
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${format("%s-pubrt", var.name)}"
    }
}