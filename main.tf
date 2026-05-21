resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "Terra-VPC"
    } 
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
        Name = "Terra-IGW"
    }
}

#Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_1_cidr
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "Terra-Public-Subnet-1"
    } 
}

#Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_2_cidr
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = "true"
    tags = {   
        Name = "Terra-Public-Subnet-2"
    }
}

#Route Table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {
        Name = "Terra-Public-RT"
    }  
}

#Route Table Association for Public Subnet 1
resource "aws_route_table_association" "public_subnet_1_association" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_subnet_2_association" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_rt.id
}

#Security Group
resource "aws_security_group" "web_sg" {
    name = "Terra-Web-SG"
    description = "Allow HTTP and SSH traffic"
    vpc_id = aws_vpc.main_vpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#EC2 Instance
resource "aws_instance" "web_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "terraform-web-server"
  }
}