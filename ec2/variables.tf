variable "aws_region" {
    default = "us-east-1"
}

variable "ami_id" {
    default = "ami-085925f297f89fce1"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "name" {
    default = "eros_server" 
  
}

variable "sg" {
    type = list
    default = ["allow-ssh", "Allow ssh inbound traffic","22","22","tcp","0.0.0.0/0","0","0","-1","0.0.0.0/0"]
  
}

variable "vpc" {
    default = "vpc-3e3c7244"
}

variable "bucket" {
    default = ["tf-bkt-test-hrq","private"]
}
