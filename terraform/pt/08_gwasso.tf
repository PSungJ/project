// IGW Route Table에 Subnet 연결
resource "aws_route_table_association" "igwrt_ass" {
    count ="${length(var.cidr.pub)}"
    subnet_id = "${aws_subnet.pub_sub[count.index].id}"
    route_table_id = aws_route_table.igw_route.id
}

// NGW Route Table에 WEB Subnet 연결
resource "aws_route_table_association" "ngwrt_web_ass" {
    count = "${length(var.cidr.web)}"
    subnet_id = "${aws_subnet.web_sub[count.index].id}"
    route_table_id = "${aws_route_table.nat_route[count.index].id}"
}