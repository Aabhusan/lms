variable "db_instance_type" {
    default="db.t2.micro"
  
}

variable "vpc_id" { 

}

variable "subnet_id"{
    type = list(string)

}


variable "main_security_group" {
    
    type = "string"
}





