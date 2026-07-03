###### Mongo DB ######
#bastion host connecting to mongodb server on port 22
resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  security_group_id = local.mongodb_sg_id # 
  source_security_group_id = local.bastion_sg_id #
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}


###### redis SG rules ######
#bastion host connecting to redis server on port 22
resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  security_group_id = local.redis_sg_id # 
  source_security_group_id = local.bastion_sg_id #
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}


######## mysql SG rules ######
#bastion host connecting to mysql server on port 22
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  security_group_id = local.mysql_sg_id # 
  source_security_group_id = local.bastion_sg_id #
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}


######## rabbitmq SG rules ######
#bastion host connecting to rabbitmq server on port 22
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  security_group_id = local.rabbitmq_sg_id # 
  source_security_group_id = local.bastion_sg_id #
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

##### ingress alb sg rules ######
resource "aws_security_group_rule" "ingress_alb_public" {
  type              = "ingress"
  security_group_id = local.ingress_alb_sg_id #
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}

##### bastion SG rules ######
#this is attached to bastion sg to allow ssh access from laptop to bastion host
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

# EKS control plane SG rules From bastion host
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  security_group_id = local.eks_control_plane_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}

# EKS node SG rules From bastion host
resource "aws_security_group_rule" "eks_node_bastion" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

#eks node SG rules from eks control plane
resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  source_security_group_id = local.eks_control_plane_sg_id
  from_port         = 0
  protocol          = "-1" # this accepts all protocols, you can also use "tcp" or "udp" if you want to restrict it to a specific protocol  
  to_port           = 0
}

#eks control plane SG rules from eks node
resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type              = "ingress"
  security_group_id = local.eks_control_plane_sg_id
  source_security_group_id = local.eks_node_sg_id
  from_port         = 0
  protocol          = "-1" # this accepts all protocols, you can also use "tcp" or "udp" if you want to restrict it to a specific protocol  
  to_port           = 0
}

# traffic from node1 to node2 in the same cluster
# Mandatory for pod to pod communication in the same cluster
resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  cidr_blocks = ["10.0.0.0/16"] # this is the VPC CIDR block, you can also use "tcp" or "udp" if you want to restrict it to a specific protocol
  from_port         = 0
  protocol          = "-1" # this accepts all protocols, you can also use "tcp" or "udp" if you want to restrict it to a specific protocol  
  to_port           = 0
}
######## open vpn SG rules ######
resource "aws_security_group_rule" "open_vpn_public" {
  type              = "ingress"
  security_group_id = local.open_vpn_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "open_vpn_943" {
  type              = "ingress"
  security_group_id = local.open_vpn_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 943
  protocol          = "tcp"
  to_port           = 943
}

resource "aws_security_group_rule" "open_vpn_443" {
  type              = "ingress"
  security_group_id = local.open_vpn_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}

resource "aws_security_group_rule" "open_vpn_1194" {
  type              = "ingress"
  security_group_id = local.open_vpn_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 1194
  protocol          = "tcp"
  to_port           = 1194
}

resource "aws_security_group_rule" "components_vpn" {
  for_each = local.vpn_ingress_rules
  type              = "ingress"
  security_group_id = each.value.sg_id
  source_security_group_id = local.open_vpn_sg_id
  from_port         = each.value.port
  protocol          = "tcp"
  to_port           = each.value.port
}