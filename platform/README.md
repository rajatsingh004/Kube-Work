# Platform extension path

The base lab deliberately keeps the application and cluster infrastructure small. Extend it in stages and document verification and rollback for each component.

1. **GitOps:** install Argo CD, keep manifests in Git, and use a least-privilege deploy identity.
2. **Progressive delivery:** add Argo Rollouts and a traffic-routing provider; define abort and rollback conditions.
3. **Ingress:** select AWS Load Balancer Controller or a Gateway API implementation, then document TLS, DNS, and network policy.
4. **Observability:** add metrics, dashboards, logs, and tracing; define alert ownership and useful SLOs.
5. **Security:** use IRSA for AWS access, image scanning, admission policy, and periodic access reviews.

Avoid installing all of these automatically in the base Terraform apply. Each has separate IAM, version, cost, and lifecycle implications.
