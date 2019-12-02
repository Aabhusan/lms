variable "lms_apache_key_name" {
  default="lms_apache_key"
}

variable "aws_ami" {  
  default= "ami-00d7116c396e73b04"
}

variable "instance_type" {
    default="t2.micro"
}

variable "subnet_id" {
  
}

variable "vpc_id" {
  
}

variable "availability_zones" {
    default = ["ap-southeast-2a"]
}



