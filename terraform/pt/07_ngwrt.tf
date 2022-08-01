resource "aws_route_table" "nat_route" {
  count  = length(var.cidr.web)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr.ngwrt
    gateway_id = aws_nat_gateway.ngw[(count.index) % 2].id
  }

  tags = {
    Name = "${format("%s-webrt", var.name)}"
  }
}
