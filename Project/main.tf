// Gateway Attachment
resource "aws_internet_gateway_attachment" "igwa" {
  internet_gateway_id = aws_internet_gateway.app_igw.id
  vpc_id              = aws_vpc.app_vpc.id
}

// Mon VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Dylan-VPC"
  }
}

// La Gateway 
resource "aws_internet_gateway" "app_igw" {

  tags = {
    Name = "Dylan-Gateway"
  }
}

// Le Module Public
module module_public {
  source        = "./module"
  vpc_id        = aws_vpc.app_vpc.id
  is_public     = true
  gateway_id    = aws_internet_gateway.app_igw.id
  dockerfile = "Imad-aws/Angular"
  git_repository_url = "https://github.com/raoufcherfa/Imad-aws.git"
}

// Le Module Private
module module_private {
  source        = "./module"
  vpc_id        = aws_vpc.app_vpc.id
  is_public     = false
  gateway_id    = aws_internet_gateway.app_igw.id
  dockerfile = "Imad-aws/backend-Python"
  git_repository_url = "https://github.com/raoufcherfa/Imad-aws.git"
}

