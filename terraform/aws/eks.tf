data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks] 
}


module "eks" {
    depends_on = [
    module.vpc.vpc_id
  ]

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster-testing-uno"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = [""] #change to my-ip  
  cluster_endpoint_private_access = true
  enable_irsa = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  eks_managed_node_groups = {
    dev-test = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.small", "t2.medium"]

      min_size     = 1
      max_size     = 4
      desired_size = 2
    }
  }

  enable_cluster_creator_admin_permissions = true 
  access_entries = {
    # One access entry with a policy associated 
    example = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::417521258013:role/jenyar"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}



module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #change
  depends_on = [module.eks]
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller    = true
  enable_cluster_proportional_autoscaler = false
  enable_karpenter                       = false
  enable_kube_prometheus_stack           = false
  enable_metrics_server                  = false
  enable_external_dns                    = false
  enable_cert_manager                    = false
#  cert_manager_route53_hosted_zone_arns  = ["arn:aws:route53:::hostedzone/XXXXXXXXXXXXX"]

  tags = {
    Environment = "dev"
  }
}


  