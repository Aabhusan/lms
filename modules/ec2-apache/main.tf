resource "tls_private_key" "lms-ec2-apache" {
    algorithm="RSA"
    rsa_bits=4096
  
}

resource "aws_key_pair" "lms-ec2-apache" {
  key_name = "${var.lms_apache_key_name}"
  public_key = "${tls_private_key.lms-ec2-apache.public_key_openssh}"
}


resource "aws_instance" "lms-ec2-apache" {

    #count                           ="${length(var.availability_zones)}"
    #name                            = "lms-apache-superset"
    ami                             ="${var.aws_ami}"
    instance_type                   ="${var.instance_type}"
    key_name                        ="${aws_key_pair.lms-ec2-apache.id}"
    subnet_id                       ="${var.subnet_id}"
    #subnet_id                       ="${element(var.subnet_id,count.index)}"
    vpc_security_group_ids                 =["${aws_security_group.lms-ec2-apache.id}"]

  


    tags = {
    Name  = "lms-ec2-apache"
    key_name      ="${aws_key_pair.lms-ec2-apache.id}"

    }
 
  
}

resource "aws_security_group" "lms-ec2-apache" {
  name          ="lms-ec2-apache_sg"
  description   ="allow all the inbound traffic"
  vpc_id        ="${var.vpc_id}"
  
  lifecycle{
        create_before_destroy=true

    }
}
resource "aws_security_group_rule" "allow_all_ssh" {
    type                ="ingress"
    from_port           = 22
    to_port             = 22
    protocol            ="tcp"
    cidr_blocks         =["0.0.0.0/0"]
    security_group_id   ="${aws_security_group.lms-ec2-apache.id}"
  
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type                    ="egress"
    from_port               =0
    to_port                 = 0
    protocol                ="-1"
    cidr_blocks             =["0.0.0.0/0"]
    security_group_id       ="${aws_security_group.lms-ec2-apache.id}"

}
