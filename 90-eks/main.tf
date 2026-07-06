module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" # this is module version, not the eks version. Check

  name               = local.common_name_suffix
  #kubernetes_version = "1.33"
  kubernetes_version = var.eks_kubernetes_version
  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
    metrics-server         = {}
  }

  # Optional
  endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids
  create_node_security_group = false
  create_security_group = false
  node_security_group_id = local.eks_node_sg_id
  security_group_id = local.eks_control_plane_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    blue = {
      create = var.enable_blue
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      kuernetes_version = var.eks_nodegroup_blue_version
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      iam_role_additional_policies = {
        amazonEBS= "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        amazonEFS= "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }
      # cluster node autoscaling
      min_size     = 2
      max_size     = 10
      desired_size = 2
    
      labels = {
        nodegroup = "blue"
      }
    }

    green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      create = var.enable_green
      kuernetes_version = var.eks_nodegroup_green_version
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      iam_role_additional_policies = {
        amazonEBS= "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        amazonEFS= "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }
      # cluster node autoscaling
      min_size     = 2
      max_size     = 10
      desired_size = 2

      
      # taints = {
      #   upgrade = {
      #     key = "upgrade"
      #     value = "true"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
      lables
        {
          nodegroup = "green"
        }
    }

  }

  tags = local.common_tags
}