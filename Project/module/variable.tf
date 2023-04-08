variable vpc_id {
    type = string
}

variable gateway_id {
    type = string
}

variable "is_public" {
  default = true  
  type        = bool
}

variable "vpc_cidr_block" {
    type = string
    default = "50.20.0.0/16"
}

variable "public_subnet_cidr_block" {
    type = string
    default = "50.20.18.0/24"
}

variable "private_subnet_cidr_block" {
    type = string
    default = "50.20.5.0/24"
}

variable "out_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}

variable "ubuntu_ami" {
    type = string
    default = "ami-0a695f0d95cefc163"
}

variable "instance_type_ec2" {
    type = string
    default = "t2.micro"
}

variable "ssh_port" {
    type = string
    default = "22"
}

variable "git_repository_url" {
  type        = string
  default = "https://github.com/raoufcherfa/Imad-aws.git"

}

variable "dockerfile" {
  type        = string
}