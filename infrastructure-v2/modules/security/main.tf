module "security_group" {
  source = "../security-group"

  environment = var.environment
  vpc_id      = var.vpc_id
  vpc_cidr    = var.vpc_cidr
}
