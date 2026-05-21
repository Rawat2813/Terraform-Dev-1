variable "aws_region" {
    description = "The AWS region to deploy resources"
    default = "us-east-1"
}

variable "vpc_cidr" {
    description = "IP address of VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
    description = "IP address of public subnet 1"
    default = "10.0.1.0/24" 
}

variable "public_subnet_2_cidr" {
    description = "IP address of public subnet 2"
    default = "10.0.2.0/24" 
}

variable "instance_type" {
    description = "EC2 instance type"
    default = "t2.micro" 
}

variable "ami_id" {
    description = "AMI ID for EC2 instance"
    default = "ami-0236922087fa98b6e"
}
