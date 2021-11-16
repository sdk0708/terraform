resource "aws_eip" "tf_eip_ng" {
  vpc = true
}

resource "aws_nat_gateway" "tf_ng" {
  allocation_id = aws_eip.tf_eip_ng.id
  subnet_id = aws_subnet.tf_pub[0].id
  tags = {
    "Name" = "${var.name}-ng"
  }
  depends_on = [
    aws_internet_gateway.tf_ig
  ]
}

resource "aws_route_table" "tf_ngrt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = var.cidr
    gateway_id = aws_nat_gateway.tf_ng.id
  }

  tags = {
    "Name" = "${var.name}-ngrt"
  }
}

resource "aws_route_table_association" "tf_ngass" {
  count = "${length(var.ava)}"
  subnet_id = aws_subnet.tf_pri[count.index].id
  route_table_id = aws_route_table.tf_ngrt.id
}