locals {
  ingress_alb_sg_id = data.aws_ssm_parameter.ingress_alb_sg_id.value
  bastion_sg_id      = data.aws_ssm_parameter.bastion_sg_id.value
  mongodb_sg_id      = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id        = data.aws_ssm_parameter.redis_sg_id.value
  rabbitmq_sg_id     = data.aws_ssm_parameter.rabbitmq_sg_id.value
  mysql_sg_id        = data.aws_ssm_parameter.mysql_sg_id.value
  open_vpn_sg_id      = data.aws_ssm_parameter.open_vpn_sg_id.value
  eks_control_plane_sg_id = data.aws_ssm_parameter.eks_control_plane_sg_id.value
  eks_node_sg_id      = data.aws_ssm_parameter.eks_node_sg_id.value

  vpn_ingress_rules = {
          mysql_22 = {
              sg_id = local.mysql_sg_id
              port = 22
          }
          mysql_3306 = {
              sg_id = local.mysql_sg_id
              port = 3306
          }
          redis = {
              sg_id = local.redis_sg_id
              port = 22
          }
          mongodb = {
              sg_id = local.mongodb_sg_id
              port = 22
          }
          rabbitmq = {
              sg_id = local.rabbitmq_sg_id
              port = 22
          }
            
      }
}

