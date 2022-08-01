// NAT에 할당할 elastic IP
resource "aws_eip" "eip_nat" {
  count = length(var.region.az)
  vpc   = true
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.cidr.pub)
  allocation_id = aws_eip.eip_nat.*.id[count.index]
  subnet_id     = aws_subnet.pub_sub.*.id[count.index]

  tags = {
    Name = "${format("%s-nat", var.name)}"
  }
}
