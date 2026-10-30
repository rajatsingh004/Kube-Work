# EKS Platform Engineering Lab

An end-to-end reference implementation for provisioning an Amazon EKS cluster and deploying a small workload with production-minded Kubernetes practices. Review settings and AWS costs before applying in an account you control.

## Demonstrates
- Terraform-managed VPC and EKS infrastructure using community modules.
- Private worker subnets, managed node groups, cluster logging, and IRSA/OIDC support.
- Workload probes, resource requests/limits, non-root execution, and a disruption budget.
- A clear extension path for GitOps, progressive delivery, and observability.

This repository contains starter configuration; it does not claim a live AWS deployment. Check module/provider compatibility and inspect `terraform plan` before applying.

## Layout
```text
terraform/       EKS and VPC infrastructure
apps/demo/       Sample workload and Kubernetes resources
platform/        Add-on installation notes
```

## Prerequisites
AWS account with required VPC/IAM/EKS/EC2 permissions, AWS CLI v2, Terraform 1.6+, kubectl, and authenticated AWS credentials.

## Deploy
Review `terraform/variables.tf` and module versions, then:

```sh
cd terraform
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
kubectl apply -f ../apps/demo/
kubectl -n demo rollout status deployment/hello
```

## Design and operations
Workers use private subnets, with API endpoint access set in Terraform. The sample runs non-root, drops Linux capabilities, declares resource requests/limits, and uses health probes. A PodDisruptionBudget protects against some voluntary disruptions but does not replace capacity planning.

Use encrypted, access-controlled remote Terraform state with locking before team use. Never commit state, plan files, credentials, or kubeconfigs.

## Cleanup
```sh
kubectl delete -f apps/demo/
cd terraform
terraform destroy
```
Check for retained load balancers, volumes, NAT gateways, and other billable resources. EKS and NAT gateways incur charges while running.

This is an educational reference, not a turnkey production platform. Validate security, quotas, availability, and costs for your environment.