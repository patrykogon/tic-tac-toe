resource "aws_vpc" "tic_tac_toe_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "TicTacToeVPC"
  }
}

resource "aws_subnet" "tic_tac_toe_subnet" {
  vpc_id                  = aws_vpc.tic_tac_toe_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "TicTacToeSubnet"
  }
}

resource "aws_internet_gateway" "tic_tac_toe_igw" {
  vpc_id = aws_vpc.tic_tac_toe_vpc.id

  tags = {
    Name = "TicTacToeIGW"
  }
}

resource "aws_route_table" "tic_tac_toe_rt" {
  vpc_id = aws_vpc.tic_tac_toe_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tic_tac_toe_igw.id
  }

  tags = {
    Name = "TicTacToeRouteTable"
  }
}

resource "aws_route_table_association" "tic_tac_toe_rta" {
  subnet_id      = aws_subnet.tic_tac_toe_subnet.id
  route_table_id = aws_route_table.tic_tac_toe_rt.id
}

resource "aws_security_group" "tic_tac_toe_sg" {
  name        = "tic-tac-toe-sg"
  description = "Security group for Tic-Tac-Toe application"
  vpc_id      = aws_vpc.tic_tac_toe_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TicTacToeSecurityGroup"
  }
}

resource "aws_instance" "tic_tac_toe_instance" {
  ami                    = "ami-0bef12ee7bc073414"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.tic_tac_toe_subnet.id
  vpc_security_group_ids = [aws_security_group.tic_tac_toe_sg.id]
  key_name               = "labskey"

  tags = {
    Name = "TicTacToeInstance"
  }
}
