name   = "ncs-test"
region = "eu-central-1"

# VPC

vpc_flowlogs                  = true
vpc_cidr                      = "10.1.0.0/16"
vpc_public_subnet_cidrs_list  = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
vpc_private_subnet_cidrs_list = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

vpc_enable_nat = true
vpc_single_nat = false # cost control

# EKS

eks_cluster_version = "1.22"
eks_public_access   = true

eks_ami_type            = "AL2_x86_64"
eks_instance_types_list = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
eks_ebs_type            = "gp3"
eks_ebs_size            = 75
eks_ebs_iops            = 3000
eks_ebs_throughput      = 150

eks_primary_group_min     = 3
eks_primary_group_max     = 10
eks_primary_group_desired = 3

# cache

redis_node_type = "cache.t3.micro"
redis_nodes_num = 3

# K8s

helm_aws_alb_version         = "1.4.2"
helm_aws_alb_namespace       = "kube-system"
helm_aws_alb_replicas        = 2
helm_metrics_server_version  = "6.0.4"
helm_metrics_server_replicas = 2