module "vpc" {
  source = "./modules/vpc"
}
module "subnets" {
  source = "./modules/subnets"
  vpc_id = "${module.vpc.vpc_id}"

}

module "routes" {
  source = "./modules/routes"
  gateway_id ="${module.vpc.gateway_id}"
  vpc_id = "${module.vpc.vpc_id}"
  nat_gateway_id  ="${module.subnets.nat_gateway_id}"
  subnet_id ="${module.subnets.public_subnet_id}"

}


module "ec2-apache" {
  source = "./modules/ec2-apache"  
  vpc_id = "${module.vpc.vpc_id}"
  subnet_id = "${module.subnets.public_subnet_id}"
}


module "rds" {
  source = "./modules/rds"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_id= module.subnets.private_subnet_id
  main_security_group = "${module.ec2-apache.main_security_group}"
  
}



