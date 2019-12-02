variable "lms_apache_key_name" {
  default="lms_apache_key"
}

variable "aws_ami" {  
  default= "ami-54d2a63b"
}

variable "instance_type" {
    default="t2.micro"
}

variable "subnet_id" {
  
}

variable "vpc_id" {
  
}

variable "availability_zones" {
    default = ["ap-south-1a"]
}



