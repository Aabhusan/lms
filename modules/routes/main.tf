resource "aws_route_table" "public" {
    vpc_id  =   "${var.vpc_id}"
    
    tags={
        Name     =      "lms public subnet route table"
        }
  
}


resource "aws_route" "public_internet_gateway" {
    route_table_id              ="${aws_route_table.public.id}"
    destination_cidr_block      ="0.0.0.0/0"
    gateway_id                  ="${var.gateway_id}"
  
}

resource "aws_route_table_association" "public" {
    count   ="${length(var.availability_zones)}"

    subnet_id           ="${element(var.subnet_id, count.index)}"
    #subnet_id           ="${element(var.public_subnet_id, count.index)}"

    

    route_table_id      ="${aws_route_table.public.id}"
      
}

resource "aws_route_table" "private" {
    count       ="${length(var.availability_zones)}"
    vpc_id      ="${var.vpc_id}"
    tags={
        Name    =" lms - private subnet route table - ${element(var.availability_zones, count.index)}"
    }
}

resource "aws_route" "nat_gateway" {
    count                       ="${length(var.availability_zones)}"
    route_table_id              ="${element(aws_route_table.private.*.id,count.index)}"

    destination_cidr_block      ="0.0.0.0/0"
    nat_gateway_id              ="${element(var.nat_gateway_id, count.index)}"


  
}

resource "aws_route_table_association" "private" {
    count               ="${length(var.availability_zones)}"
    subnet_id           ="${element(var.subnet_id, count.index)}"
    

    route_table_id      ="${element(aws_route_table.public.*.id, count.index)}"

}



