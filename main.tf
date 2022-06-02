/**
 * # K8s Infrastructure with cache and DB
 *
 * ## Overview
 *
 * ![aws-eks-cache-db.png](./aws-eks-cache-db.png)
 * 
 * ## Usage 
 *
 * * Initialize with `terraform init`.
 * * Create workspaces with `terraform workspace select develop || terraform workspace new develop` (or production of course).
 * * Run `terraform apply -var-file=environments/develop/terraform.tfvars (or production of course).
 *
 * You should set up remote state, too.
 */

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = var.vpc_cidr

  azs             = [local.azs[0], local.azs[1], local.azs[2]] #["${local.region}a", "${local.region}b", "${local.region}c"] was soo ugly
  private_subnets = var.vpc_private_subnet_cidrs_list
  public_subnets  = var.vpc_public_subnet_cidrs_list

  enable_nat_gateway   = var.vpc_enable_nat
  single_nat_gateway   = var.vpc_single_nat
  enable_dns_hostnames = true

  enable_flow_log                      = var.vpc_flowlogs
  create_flow_log_cloudwatch_iam_role  = var.vpc_flowlogs
  create_flow_log_cloudwatch_log_group = var.vpc_flowlogs

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.21"

  cluster_name                    = local.name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = var.eks_public_access
  manage_aws_auth_configmap       = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = module.eks_keys.eks_arn # moved aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = var.eks_ami_type
    instance_types = var.eks_instance_types_list

    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [module.security_groups["eks-additional"].id] #[aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    primary = {
      min_size     = var.eks_primary_group_min
      max_size     = var.eks_primary_group_max
      desired_size = var.eks_primary_group_desired

      create_launch_template = false
      launch_template_name   = ""

      ebs_optimized = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.eks_ebs_size
            volume_type           = var.eks_ebs_type
            iops                  = var.eks_ebs_iops
            throughput            = var.eks_ebs_throughput
            encrypted             = true
            kms_key_id            = module.eks_keys.ebs_arn # aws_kms_key.ebs.arn
            delete_on_termination = true
          }
        }
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      # Remote access cannot be specified with a launch template
      remote_access = {
        ec2_ssh_key               = module.aws_key.name
        source_security_group_ids = [module.security_groups["remote-access"].id] #[aws_security_group.remote_access.id]
      }

      labels = {
        Environment = "blue"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
    }
  }


  tags = local.tags
}

module "eks_keys" {
  source           = "./modules/eks-keys"
  name             = local.name
  cluster_role_arn = module.eks.cluster_iam_role_arn

  tags = local.tags
}

module "aws_key" {
  source = "./modules/aws-keys"

  name = local.name
  tags = local.tags
}

module "security_groups" {
  source = "./modules/aws-sg"

  for_each = toset(local.security_groups)
  name     = local.name
  purpose  = each.value
  vpc_id   = module.vpc.vpc_id

  tags = local.tags
}

module "cache" {
  source = "./modules/aws-elasticache-redis"

  name               = local.name
  node_type          = var.redis_node_type
  security_group_ids = [module.security_groups["cache"].id]
  subnet_ids         = module.vpc.private_subnets
  nodes_num          = var.redis_nodes_num

  tags = local.tags
}

module "aws_load_balancer_controller" {
  source        = "./modules/helm-aws-alb-controller"
  chart_version = var.helm_aws_alb_version

  cluster_name               = module.eks.cluster_id
  oidc_eks_url               = module.eks.oidc_provider
  oidc_eks_arn               = module.eks.oidc_provider_arn
  replica_count              = var.helm_aws_alb_replicas
  ingress_class              = "alb"
  createIngressClassResource = "false"
  namespace                  = var.helm_aws_alb_namespace
}

module "metrics-server" {
  source        = "./modules/helm-metrics-server"
  chart_version = var.helm_metrics_server_version
  replica_count = var.helm_metrics_server_replicas
}