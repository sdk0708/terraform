resource "aws_internet_gateway" "tf_ig" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    "Name" = "${var.name}-ig"
  }
}

resource "aws_route_table" "tf_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = var.cidr
    gateway_id = aws_internet_gateway.tf_ig.id
  }
  tags = {
    "Name" = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "tf_rtas_a"{
  count = length(var.cidr_public)
  subnet_id = aws_subnet.tf_pub[count.index].id
  route_table_id = aws_route_table.tf_rt.id
  }
