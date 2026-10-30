locals {
  read_group  = "${var.role_name}-readers"
  write_group = "${var.role_name}-writers"
  read_verbs  = ["get", "list", "watch"]
  write_verbs = ["create", "delete", "get", "list", "patch", "update", "watch"]
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
    labels = {
      "pod-security.kubernetes.io/enforce" = "restricted"
      "app.kubernetes.io/managed-by"        = "terraform"
    }
  }
}

resource "aws_eks_access_entry" "read" {
  count             = contains(["read", "read-write"], var.permission_type) ? 1 : 0
  cluster_name      = var.cluster_name
  principal_arn     = var.read_iam_arn
  kubernetes_groups = [local.read_group]
  type              = "STANDARD"
  tags              = var.tags
  lifecycle {
    precondition {
      condition     = var.read_iam_arn != null && var.read_iam_arn != ""
      error_message = "read_iam_arn is required when permission_type includes read access."
    }
  }
}

resource "aws_eks_access_entry" "write" {
  count             = contains(["write", "read-write"], var.permission_type) ? 1 : 0
  cluster_name      = var.cluster_name
  principal_arn     = var.write_iam_arn
  kubernetes_groups = [local.write_group]
  type              = "STANDARD"
  tags              = var.tags
  lifecycle {
    precondition {
      condition     = var.write_iam_arn != null && var.write_iam_arn != ""
      error_message = "write_iam_arn is required when permission_type includes write access."
    }
  }
}

resource "kubernetes_role_v1" "read" {
  count = contains(["read", "read-write"], var.permission_type) ? 1 : 0
  metadata {
    name      = "${var.role_name}-read"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  rule {
    api_groups = ["", "apps", "batch", "networking.k8s.io"]
    resources  = var.resources
    verbs      = local.read_verbs
  }
}

resource "kubernetes_role_v1" "write" {
  count = contains(["write", "read-write"], var.permission_type) ? 1 : 0
  metadata {
    name      = "${var.role_name}-write"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  rule {
    api_groups = ["", "apps", "batch", "networking.k8s.io"]
    resources  = var.resources
    verbs      = local.write_verbs
  }
}

resource "kubernetes_role_binding_v1" "read" {
  count = contains(["read", "read-write"], var.permission_type) ? 1 : 0
  metadata {
    name      = "${var.role_name}-read"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.read[0].metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = local.read_group
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_role_binding_v1" "write" {
  count = contains(["write", "read-write"], var.permission_type) ? 1 : 0
  metadata {
    name      = "${var.role_name}-write"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.write[0].metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = local.write_group
    api_group = "rbac.authorization.k8s.io"
  }
}
