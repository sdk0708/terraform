resource "aws_security_group" "tf_sg" {
  name = "Allow Basic"
  description = "Allow HTTP,SSH,SQL,ICMP"
  vpc_id = aws_vpc.tf_vpc.id

  ingress = [
    {
      description      = var.protocol_http
      from_port        = var.port_http
      to_port          = var.port_http
      protocol         = var.protocol_tcp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = var.protocol_ssh
      from_port        = var.port_ssh
      to_port          = var.port_ssh
      protocol         = var.protocol_tcp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = var.db_name
      from_port        = var.port_mysql
      to_port          = var.port_mysql
      protocol         = var.protocol_tcp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = var.protocol_icmp
      from_port        = var.port_zero
      to_port          = var.port_zero
      protocol         = var.protocol_icmp
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      description      = "ALL"
      from_port        = var.port_zero
      to_port          = var.port_zero
      protocol         = var.protocol_minus
      cidr_blocks      = [var.cidr]
      ipv6_cidr_blocks = [var.cidr_v6]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  tags = {
    "Name" = "${var.name}-sg"
  }
}

data "aws_ami" "amzn" {
  most_recent = true
  
  filter {
    name  = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "tf_web" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = var.instance
  key_name               = var.key
  availability_zone      = "${var.region}${var.ava[0]}"
  private_ip             = var.private_ip
  subnet_id              = aws_subnet.tf_pub[0].id #public_subnet a의 ID
  vpc_security_group_ids = [aws_security_group.tf_sg.id]
  user_data              = file("./intall.sh")
}

resource "aws_eip" "tf_web_ip" {
  vpc                       = true
  instance                  = aws_instance.tf_web.id
  associate_with_private_ip = var.private_ip
  depends_on = [
    aws_internet_gateway.tf_ig
  ]
}