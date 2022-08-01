// public subnet
resource "aws_subnet" "pub_sub" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.cidr.pub)
  cidr_block        = var.cidr.pub[count.index]
  availability_zone = "${var.region.region}${var.region.az[count.index%2]}"

  tags = {
    Name = "${format("pub-%s", var.region.az[count.index%2])}"
  }
}

// web subnet - private
resource "aws_subnet" "web_sub" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.cidr.web)
  cidr_block        = var.cidr.web[count.index]
  availability_zone = "${var.region.region}${var.region.az[count.index%2]}"

  tags = {
    Name = "${format("web-%s", var.region.az[count.index%2])}"
  }
}

// db subnet - private
resource "aws_subnet" "db_sub" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.cidr.db)
  cidr_block        = var.cidr.db[count.index]
  availability_zone = "${var.region.region}${var.region.az[count.index%2]}"

  tags = {
    Name = "${format("db-%s", var.region.az[count.index%2])}"
  }
}
