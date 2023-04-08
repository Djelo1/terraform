// Public Subnet
resource "aws_subnet" "public_subnet" {
  count      = var.is_public ? 1 : 0
  cidr_block = var.public_subnet_cidr_block
  vpc_id     = var.vpc_id

  tags = {
    Name = "Dylan Public Subnet"
  }
}

// Private Subnet
resource "aws_subnet" "private_subnet" {
  count      = var.is_public ? 0 : 1
  cidr_block = var.private_subnet_cidr_block
  vpc_id     = var.vpc_id

  tags = {
    Name = "Dylan Private Subnet"
  }
}

// Route Table Public
resource "aws_route_table" "public_route_table" {
  count = var.is_public ? 1 : 0
  vpc_id = var.vpc_id
  route {
    cidr_block = var.out_cidr_block
    gateway_id = var.gateway_id
  }

    tags = {
    Name = "Dylan Public Table"
  }
}
// Route Table Private
resource "aws_route_table" "private_route_table" {
  count = var.is_public ? 0 : 1
  vpc_id = var.vpc_id
  tags = {
    Name = "Dylan Private Table"
  }
}

//Associate Route Table to Subnet
resource "aws_route_table_association" "public_subnet_assoc" {
  count = var.is_public ? 1 : 0
  route_table_id = aws_route_table.public_route_table[count.index].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table_association" "private_subnet_assoc" {
  count = var.is_public ? 0 : 1
  route_table_id = aws_route_table.private_route_table[0].id
  subnet_id      = aws_subnet.private_subnet[0].id
}

//Create Security Group
resource "aws_security_group" "sg_dylan" {
  name_prefix = var.is_public ? "sg_dylan_public" : "sg_dylan_private"
  vpc_id = var.vpc_id
  
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.out_cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.out_cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.out_cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.out_cidr_block]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [var.out_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.out_cidr_block]
  }
  tags = {
    Name = "Dylan Security Group"
  }
}

// EC2 Pulic
resource "aws_instance" "ec1" {
  count                  = var.is_public ? 1 : 0
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type_ec2
  subnet_id              =  var.is_public ? aws_subnet.public_subnet[count.index].id : aws_subnet.private_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.sg_dylan.id]
  associate_public_ip_address = "true"
  key_name = "key_dylan"

    
  user_data = <<EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt install git -y
              git clone ${var.git_repository_url}
              cd ${var.dockerfile}
              docker build 

            
              EOF

   tags = {
    Name = "Dylan_EC2_Public"
  }
}

// EC2 Private
resource "aws_instance" "ec2" {
  count                  = var.is_public ? 0 : 1
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type_ec2
  subnet_id              = var.is_public ? aws_subnet.public_subnet[0].id : aws_subnet.private_subnet[0].id
  vpc_security_group_ids = [aws_security_group.sg_dylan.id]

   tags = {
    Name = "Dylan_EC2_Private"
  }

}
