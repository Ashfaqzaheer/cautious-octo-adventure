provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.cidr_block
  name       = var.name
}

# Create Second VPC
module "vpc2" {
  source     = "./modules/vpc"
  cidr_block = "10.1.0.0/16"
  name       = "vpc2"
}

# module "subnet" {
#   source       = "./modules/subnet"
#   vpc_id = module.vpc.vpc_id
#   public_cidr  = var.public_subnet_cidr
#   private_cidr = var.private_subnet_cidr
#   subnet_cidr = var.subnet_cidr 
#   azs          = var.azs
# }

module "private_subnet2" {
  source            = "./modules/private-subnet"
  vpc_id            = module.vpc2.vpc_id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "ap-south-1b"
  name              = "private-subnet-vpc2"
}


module "internet_gateway" {
  source = "./modules/igw"
  vpc_id = module.vpc2.vpc_id
}

module "route_table" {
  source           = "./modules/route-table"
  vpc_id           = module.vpc2.vpc_id
  igw_id           = module.internet_gateway.igw_id
 public_subnet_id = module.private_subnet2.private_subnet_id


}

# module "ec2" {
#   source           = "./modules/ec2"
#   ami_id = "ami-0af9569868786b23a"  # Replace with your actual AMI ID
#   my_ip  = "106.222.229.231/32"             # Replace with your IP or a variable
#   vpc_id = "vpc-02d11a34449d902f6" 
#   key_name = "mystudentkey"
#   private_subnet_id = "subnet-08d822f92377411bb"
#    public_subnet_id = "subnet-0512f293e1e66e37a"
# }


# module "nat_gateway" {
#   source          = "./modules/nat-gateway"
#   public_subnet_id = module.subnet.public_subnet_id
#   allocation_id    = module.nat_gateway.eip_id
#   vpc_id           = module.vpc.vpc_id
#   private_subnet_id = module.subnet.private_subnet_id
# }

# module "nacl" {
#   source     = "./modules/nacl"
#   vpc_id = module.vpc.vpc_id
#   subnet_id  = module.subnet.public_subnet_id
#   my_ip      = var.my_ip
# }


# module "flow_logs" {
#   source = "./modules/flow-logs"
#   vpc_id = "vpc-02d11a34449d902f6"
# }



module "peering" {
  source           = "./modules/peering"
  vpc_id_1         = "<vpc-02d11a34449d902f6>"
  vpc_id_2         = "<vpc-03006a741ffb3ffe8>"
  route_table_id_1 = "<0d59cc26bc23272efD>"
  route_table_id_2 = "<0b8affd83275d1fdb>"
  vpc_1_cidr       = "10.0.0.0/16"
  vpc_2_cidr       = "10.1.0.0/16"
}






