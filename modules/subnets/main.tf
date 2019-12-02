locals {
  public_subnet_count = var.max_subnet_count == 0 ? length(var.availabilty_zones) : var.max_subnet_count
  private_subnet_count = var.max_subnet_count == 0 ? length(var.availabilty_zones) : var.max_subnet_count
}

#creating the private subnet
resource "aws_subnet" "private" {
    count                       ="${length(var.availabilty_zones)}"
    vpc_id                      ="${var.vpc_id}"
    #cidr_block                  ="${cidrsubnet(var.cidr_block, 8, count.index)}" 
    
    cidr_block = cidrsubnet(
    var.cidr_block,
    ceil(log(local.private_subnet_count * 2, 2)),
    count.index
  )

    
    
    availability_zone           ="${element(var.availabilty_zones, count.index+length(var.availabilty_zones))}" 
    map_public_ip_on_launch     = false

    tags={
        Name= "private subnet - ${element(var.availabilty_zones, count.index)}"
    }

}
#creating the public subnet
resource "aws_subnet" "public" {
    count                    ="${length(var.availabilty_zones)}"
    vpc_id                   ="${var.vpc_id}"
    #cidr_block               ="${cidrsubnet(var.cidr_block, 8, count.index)}" 

    cidr_block = cidrsubnet(
    var.cidr_block,
    ceil(log(local.public_subnet_count * 2, 2)),
    local.public_subnet_count + count.index
  )
    

    availability_zone        ="${element(var.availabilty_zones, count.index)}" 
    map_public_ip_on_launch  =true

    tags={
        Name= "public subnet -${element(var.availabilty_zones, count.index)}"
    }

}





#creatinf the elastic ip address
resource "aws_eip" "nat" {
    count   ="${length(var.availabilty_zones)}"
    vpc     = true
}

#creating the nat gateway
resource "aws_nat_gateway" "main" {
    count           = "${length(var.availabilty_zones)}"
    subnet_id       ="${element(aws_subnet.public.*.id ,count.index)}"
    allocation_id   ="${element(aws_eip.nat.*.id, count.index)}"

    tags={
        Name = "lms-main- ${element(var.availabilty_zones, count.index)}"
    }
  
}



