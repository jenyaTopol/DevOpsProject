
module "attach_efs_csi_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}

resource "helm_release" "aws_efs_csi_driver" {
  chart      = "aws-efs-csi-driver"
  name       = "aws-efs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/eks/aws-efs-csi-driver"
  }

  set {
    name  = "controller.serviceAccount.create"
    value = true
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.attach_efs_csi_role.iam_role_arn
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
}


resource "aws_security_group" "allow_nfs" {
  name        = "allow nfs for efs"
  description = "Allow NFS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


resource "aws_efs_file_system" "stw_node_efs" {
  creation_token = "efs-for-stw-node"
}


resource "aws_efs_mount_target" "stw_node_efs_mt_0" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id       = module.vpc.private_subnets
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "aws_efs_mount_target" "stw_node_efs_mt_1" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id       = module.vpc.private_subnets
  security_groups = [aws_security_group.allow_nfs.id]
}

resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.stw_node_efs.id
  posix_user {
    gid = 1001
    uid = 1001
  }
  root_directory {
    path = "/path0"
    creation_info {
      owner_gid   = 1001  
      owner_uid   = 1001  
      permissions = "755"  
    }
  }
}