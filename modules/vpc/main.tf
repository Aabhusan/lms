resource "aws_vpc" "main" {
  cidr_block="${var.cidr_block}"

  tags={
      name= "lms"
  }
  
}


resource "aws_internet_gateway" "main" {
  vpc_id="${aws_vpc.main.id}"
  
  tags={
      name="lms-igw"
  }

}       

