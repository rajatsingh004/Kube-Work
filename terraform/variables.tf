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
  description = "EKS version supported by the module and selected region."
  type        = string
  default     = "1.31"
}

variable "vpc_cidr" {
  description = "Lab VPC CIDR."
  type        = string
  default     = "10.40.0.0/16"
}

variable "availability_zones" {
  description = "Choose two valid availability zones in the selected region."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "node_instance_types" {
  description = "Managed node group EC2 instance types."
  type        = list(string)
  default     = ["t3.large"]
}
