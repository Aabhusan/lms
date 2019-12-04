locals {
  public_subnet_count = var.max_subnet_count == 0 ? length(var.availability_zones) : var.max_subnet_count
  private_subnet_count = var.max_subnet_count == 0 ? length(var.availability_zones) : var.max_subnet_count
}

#creating the private subnet
resource "aws_subnet" "private" {
    count                       ="${length(var.availability_zones)}"
    vpc_id                      ="${var.vpc_id}"

    

    #cidr_block                  ="${cidrsubnet(var.cidr_block, 4, 0)}" 
    
    cidr_block = cidrsubnet(
    var.cidr_block,
    ceil(log(local.private_subnet_count * 2, 2)),
    count.index
  )

    
    #availability_zone            = "${var.availability_zones}"
    availability_zone           ="${element(var.availability_zones, count.index+length(var.availability_zones))}" 
    map_public_ip_on_launch     = false

    tags={
        #name = "privat subnet lms "
        Name= "private subnet - ${element(var.availability_zones, count.index)}"
    }

}
#creating the public subnet
resource "aws_subnet" "public" {
    #count                    ="${length(var.availability_zones)}"
    vpc_id                   ="${var.vpc_id}"
    
    cidr_block               ="${cidrsubnet(var.cidr_block, 2, 3)}" 

    # cidr_block = cidrsubnet(
    # var.cidr_block,
    # ceil(log(local.public_subnet_count * 2, 2)),
    # local.public_subnet_count + count.index
    # )
    
    availability_zone= "${element(var.availability_zones,1)}"
    #availability_zone        ="${element(var.availability_zones, count.index)}" 
    map_public_ip_on_launch  =true

    tags={
        #Name= "public subnet -${element(var.availabilty_zones, count.index)}"
        Name= "public subnet lms"
    }

}





#creatinf the elastic ip address
resource "aws_eip" "nat" {
    #count   ="${length(var.availability_zones)}"
    vpc     = true
}

#creating the nat gateway
resource "aws_nat_gateway" "main" {
    #count           = "${length(var.availability_zones)}"
    subnet_id       ="${aws_subnet.public.id}"
    allocation_id   ="${aws_eip.nat.id}"
    # subnet_id       ="${element(aws_subnet.public.*.id ,count.index)}"
    # allocation_id   ="${element(aws_eip.nat.*.id, count.index)}"

    tags={
        name = "lms-main nat"
        #Name = "lms-main- ${element(var.availability_zones, count.index)}"
    }
  
}



