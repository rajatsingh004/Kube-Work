variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "namespace" {
  type        = string
  description = "Namespace managed by this access module."
}
variable "role_name" {
  type        = string
  description = "Team name prefix for roles and EKS groups."
}
variable "permission_type" {
  type        = string
  default     = "read"
  description = "One of read, write, or read-write."
  validation {
    condition     = contains(["read", "write", "read-write"], var.permission_type)
    error_message = "permission_type must be read, write, or read-write."
  }
}
variable "read_iam_arn" {
  type        = string
  default     = null
  description = "IAM role ARN used for read access."
}
variable "write_iam_arn" {
  type        = string
  default     = null
  description = "IAM role ARN used for write access."
}
variable "resources" {
  type        = list(string)
  description = "Kubernetes resources allowed in the namespace."
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags on EKS access entries."
}
