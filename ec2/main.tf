provider "aws" {
    region = var.aws_region
}

resource "aws_key_pair" "deployer" {
    key_name = "deployer"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "ubuntu" {
    ami = var.ami_id
    instance_type = var.instance_type
    availability_zone = "${var.aws_region}a"
    key_name = aws_key_pair.deployer.key_name
    security_groups = [aws_security_group.allow-ssh.name]

    tags = {
        Name = var.name
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "hostnamectl",
            "uname -r"
        ]
    }
    depends_on = [aws_s3_bucket.b]
}

data "aws_vpc" "default" {
    id = var.vpc
}

resource "aws_s3_bucket" "b" {
    bucket = var.bucket[0]
    acl = var.bucket[1]
}

resource "aws_security_group" "allow-ssh" {
    name = var.sg[0]
    description = var.sg[1]
    vpc_id = data.aws_vpc.default.id
  
    ingress {
        from_port = var.sg[2]
        to_port = var.sg[3]
        protocol = var.sg[4]
        cidr_blocks = [var.sg[5]]
    }

    egress{
        from_port = var.sg[6]
        to_port = var.sg[7]
        protocol = var.sg[8]
        cidr_blocks = [var.sg[9]]        
    }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.ubuntu.id
}