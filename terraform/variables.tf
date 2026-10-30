variable "region" {
  description = "AWS region for the lab."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Unique EKS cluster name."
  type        = string
  default     = "platform-lab"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version supported by the selected module and region."
  type        = string
  default     = "1.35"
}

variable "vpc_cidr" {
  description = "CIDR range for the lab VPC."
  type        = string
  default     = "10.40.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used for the VPC."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group."
  type        = list(string)
  default     = [" t3.large"]
}
