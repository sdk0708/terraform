provider "aws" {
  region = var.region
}

resource "aws_key_pair" "tf_key" {
  key_name = var.key
  public_key = file("../../.ssh/tf-key-pair.pub")
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = var.cidr_main
  tags = {
    Name = "$(var.name)-vpc"
  }
}

resource "aws_subnet" "tf_pub"{
  count = length(var.cidr_public) #2
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.cidr_public[count.index]
  availability_zone = "${var.region}${var.ava[count.index]}"
  tags = {
  "Name"="${var.name}-pub${var.ava[count.index]}"
  }
}

resource "aws_subnet" "tf_pri"{
  count = length(var.cidr_private)
vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.cidr_private[count.index]
  availability_zone = "${var.region}${var.ava[count.index]}"
  tags = {
  "Name"="${var.name}-pri${var.ava[count.index]}"
  }
}

resource "aws_subnet" "tf_pridb"{
  count = length(var.cidr_privatedb)
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = var.cidr_privatedb[count.index]
  availability_zone = "${var.region}${var.ava[count.index]}"
  tags = {
  "Name"="${var.name}-pridb${var.ava[count.index]}"
  }
}


