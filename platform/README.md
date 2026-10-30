# Platform extension path

Add capabilities in separately reviewed steps; each has its own IAM, compatibility, cost, and rollback requirements.

1. Install Argo CD for GitOps with a least-privilege deploy identity.
2. Add Argo Rollouts and traffic routing for progressive delivery, including abort criteria.
3. Select an ingress/Gateway API implementation and document TLS, DNS, and network policy.
4. Add metrics, dashboards, logs, tracing, alert ownership, and service objectives.
5. Add image scanning, admission policy, IRSA usage, and periodic access reviews.

These components are not installed automatically by the base Terraform configuration.
