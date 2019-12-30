resource "aws_db_instance" "lms" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.1"
  instance_class       = "${var.db_instance_type}"
  name                 = "lmsDB"
  username             = "lms"
  password             = "leapfroglms123"
  parameter_group_name = "default.postgres11"
  #parameter_group_name = "${aws_db_parameter_group.default.id}"
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  max_allocated_storage = 100
  deletion_protection   = false
  vpc_security_group_ids=["${aws_security_group.rds.id}"]
  #security_group_names  = ["${aws_security_group.rds.id}"]
  
}




# resource "aws_db_parameter_group" "default" {
#   name   = "lms-rds-pg"
#   family = "postgres11"

#   parameter {
#     name  = "character_set_server"
#     value = "utf8"
#   }
# }

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
        from_port=5432
        to_port=5432
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
        name= "allow ec2 to access postgres-db"
    }   
}

resource "aws_db_parameter_group" "wavemaker" {
    provider = aws.mumbai
    family   = "postgres9.5"
    name     = "wavemaker-paramater-group"
}


resource "aws_db_instance" "rds-2" {
  provider = aws.mumbai

  allocated_storage    = 30
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.5"
  instance_class       = "${var.db_instance_type}"
  name                 = "database1"
  username             = "aabhusan"
  password             = ""
  parameter_group_name = "${aws_db_parameter_group.wavemaker.name}"
  db_subnet_group_name = "${aws_db_subnet_group.rds-2.name}"
  max_allocated_storage = 100
  deletion_protection   = false
  publicly_accessible   = true
  skip_final_snapshot   = true
  vpc_security_group_ids=["${aws_security_group.rds-2.id}"]
}





resource "aws_security_group" "rds-2" {
    provider = aws.mumbai
    name= "db2_rds_sg"
    vpc_id= "vpc-0e555cebd2854b4d3"
    
    lifecycle{
        create_before_destroy=true

    }

    ingress{
        from_port=5432
        to_port=5432
        protocol="tcp"
        cidr_blocks=["202.70.67.113/32","182.93.83.51/32","202.166.206.8/32","202.79.34.78/32","0.0.0.0/0"]

    }
    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        self= true
    }
    tags={
        name= "rds2-sg"
    }   
}

resource "aws_db_subnet_group" "rds-2" {

  provider = aws.mumbai
  name       = "rds-2_subnet_group"
  subnet_ids = ["subnet-0d4598adf89c10a0f","subnet-0c57237db35480d2d"]
  tags = {
    Name = "My DB subnet group for rds-2"
  }
}


