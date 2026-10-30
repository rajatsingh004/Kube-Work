# EKS Access Management Module

The source Terraform module tied IAM principals to EKS access entries and namespace-scoped Kubernetes Roles/RoleBindings. It exposed read, write, and read-write permission modes. This module layout preserves that goal but fixes two important design issues: access-entry counts are derived directly from the permission type, and namespace lifecycle is managed as a Kubernetes resource rather than a `local-exec kubectl` command.

The module binds EKS access-entry groups to namespace RoleBindings. The caller must choose resources and verbs deliberately. Avoid broad access to Secrets, exec, port-forward, or wildcard API groups by default. Provider authentication should use a short-lived AWS role identity and a Kubernetes provider configured against the selected EKS endpoint.

```hcl
module "team_access" {
  source              = "./access-management"
  cluster_name        = "demo-eks"
  namespace           = "demo"
  role_name           = "platform-team"
  permission_type     = "read-write"
  read_iam_arn        = "arn:aws:iam::000000000000:role/demo-platform-read"
  write_iam_arn       = "arn:aws:iam::000000000000:role/demo-platform-write"
  resources           = ["pods", "services", "deployments", "events"]
}
```

Choose an EKS authentication mode that supports access entries. The read and write IAM roles must be distinct and have no broader cluster-admin grants that defeat namespace scoping.
