module "sg" {
  count          = length(var.sg_name)
  source         = "git::https://github.com/Shankar-codes/terraform-security-group.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  sg_name        = var.sg_name[count.index]
  sg_description = var.sg_description
  vpc_id         = local.vpc_id
}
