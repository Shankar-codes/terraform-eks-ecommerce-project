variable "project_name" {
  default = "ellamma-roboshop"
}

variable "environment" {
  default = "dev"
}

variable "sg_name" {
  default = [
  #databases
  "mongodb", "redis", "mysql", "rabbitmq",
  #backend
  #"catalogue", "user", "cart", "shipping", "payment", moving this to eks
  #frontend
  #"frontend",
  #bastion
  "bastion",
  #we are using ingress_alb instead of frontend alb
  "ingress_alb",
  #backend alb
  #"backend_alb",
  #open vpn
  "open_vpn",
  "eks_control_plane",
  "eks_node"
  ]
}

variable "sg_description" {
  default = "Security group"
}