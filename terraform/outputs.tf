output "cluster_name" { description = "EKS cluster name."; value = module.eks.cluster_name }
output "cluster_endpoint" { description = "Kubernetes API endpoint."; value = module.eks.cluster_endpoint }
output "region" { description = "AWS region."; value = var.region }
output "vpc_id" { description = "VPC ID."; value = module.vpc.vpc_id }
