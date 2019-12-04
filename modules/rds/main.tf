resource "aws_db_instance" "lms" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "${var.db_instance_type}"
  name                 = "lmsDB"
  username             = "lms"
  password             = "leapfroglms123"
  parameter_group_name = "${aws_db_parameter_group.default.id}"
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  max_allocated_storage = 100
  deletion_protection   = true
  vpc_security_group_ids=["${aws_security_group.rds.id}"]
  #security_group_names  = ["${aws_security_group.rds.id}"]
  
}




resource "aws_db_parameter_group" "default" {
  name   = "lms-rds-pg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "lms_subnet_group"
  subnet_ids = var.subnet_id
  tags = {
    Name = "My DB subnet group"
  }
}

 

resource "aws_security_group" "rds" {
    name= "lms_rds_sg"
    vpc_id= "${var.vpc_id}"
    
    lifecycle{
        create_before_destroy=true

    }

    ingress{
        from_port=3360
        to_port=3360
        protocol="tcp"
        security_groups=["${var.main_security_group}"]

    }
    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        self= true
    }
    tags={
        name= "allow ec2 to access mysql-db"
    }   
}




