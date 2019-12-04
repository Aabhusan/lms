variable "lms_apache_key_name" {
  default="lms_apache_key"
}

variable "aws_ami" {  
  default= "ami-0eacc5b7915ba9921"
}

variable "instance_type" {
    type= "string"
    default="t2.micro"
}

variable "subnet_id" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
  
}

variable "availability_zones" {
  type  ="list"
  default = ["ap-south-1a"]

}



