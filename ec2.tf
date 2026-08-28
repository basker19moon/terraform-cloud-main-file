module "dev_compute_1" {
  source      = "app.terraform.io/basker_bddevops/compute/modules"
  version     = "1.0.0"
  environment = module.dev_vpc_1.environment
  amis = {
    us-east-1 = "ami-0b6d9d3d33ba97d99" # ubuntu 20.04 LTS
    us-east-2 = "ami-0e5497a77ef21b5ac" # ubuntu 20.04 LTS
  }
  aws_region           = var.aws_region
  instance_type        = "t3.micro"
  key_name             = "mypractice"
  iam_instance_profile = module.dev_iam_1.instprofile
  public_subnets       = module.dev_vpc_1.public_subnets_id
  private_subnets      = module.dev_vpc_1.private_subnets_id
  sg_id                = module.dev_sg_1.sg_id
  vpc_name             = module.dev_vpc_1.vpc_name
  elb_listener         = module.dev_elb_1.elb_listner
  elb_listener_public  = module.dev_elb_1_public.elb_listner
}

module "dev_elb_1" {
  source          = "app.terraform.io/basker_bddevops/elb/modules"
  version         = "1.0.0"
  environment     = module.dev_vpc_1.environment
  nlbname         = "dev-nlb"
  subnets         = module.dev_vpc_1.public_subnets_id
  tgname          = "dev-nlb-tg"
  vpc_id          = module.dev_vpc_1.vpc_id
  private_servers = module.dev_compute_1.private_servers
}

module "dev_elb_1_public" {
  source          = "app.terraform.io/basker_bddevops/elb/modules"
  version         = "1.0.0"
  environment     = module.dev_vpc_1.environment
  nlbname         = "dev-nlb-public"
  subnets         = module.dev_vpc_1.public_subnets_id
  tgname          = "dev-nlb-tg-public"
  vpc_id          = module.dev_vpc_1.vpc_id
  private_servers = module.dev_compute_1.public_servers
}

module "dev_iam_1" {
  source              = "app.terraform.io/basker_bddevops/iam/modules"
  version             = "1.0.0"
  environment         = module.dev_vpc_1.environment
  rolename            = "BDTMRole"
  instanceprofilename = "BDTMinstprofile"
}
