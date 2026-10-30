# Kubernetes Platform Engineering: EKS, Istio, Argo Rollouts, and Secrets

This repository captures a substantive EKS platform workstream: Kubernetes implementation planning, progressive delivery, traffic management with Istio, workload identity and AWS Secrets Manager integration, and operational readiness. It includes deployable manifests and infrastructure code rather than a summary-only case study.

The examples are anonymized adaptations of the source materials. Application names, domains, accounts, repositories, and customer identifiers use `demo` and `example.com`. The portfolio documents design and tested patterns, but these public manifests have not been applied to a live AWS account.

## Work represented

### Progressive delivery and traffic shaping

- **Three-farm Istio traffic split:** an explicit 98% stable / 1% candidate / 1% control split using `VirtualService` weights and `DestinationRule` subsets. This represents the source canary experiment where a small amount of traffic exercised new and prior code paths alongside the primary deployment.
- **Argo Rollouts canary:** a separate Rollout resource progressively moves traffic from stable to canary, with pauses and operator promotion. Argo manages two active versions in this pattern; it does not represent the three-farm split above.
- **Argo Rollouts blue/green:** active and preview Services keep candidate validation distinct from traffic promotion.
- **Istio mTLS:** guidance covers mesh CNI/network prerequisites, permissive-to-strict mTLS transition, and destination subset alignment.

### EKS secrets integration

The Secret Store CSI example mounts an AWS Secrets Manager value into a pod using a dedicated Kubernetes service account and workload identity. It avoids placing secret material in manifests, ConfigMaps, Terraform variables, or container images.

### Cluster access and operations

Terraform examples define namespace-scoped read/write RBAC and EKS access-entry boundaries. The operating notes cover Gateway/CNI assumptions, rollout observability, rollback, and validation from an in-cluster client rather than relying on a port-forward to an Envoy listener.

## Repository map

```text
terraform/                     EKS infrastructure starter
apps/demo/                     hardened sample app
progressive-delivery/
  istio-three-farm/            98/1/1 VirtualService + subsets + sample Deployments
  argo-rollouts/canary/         progressive traffic shift through Istio
  argo-rollouts/blue-green/     preview/active service promotion
secrets/aws-secrets-manager/    Secret Store CSI / workload identity example
access-management/              namespace RBAC and EKS identity pattern
docs/                           implementation and operations notes
```

## Validation sequence

1. Confirm EKS VPC CNI and pod networking are healthy before installing the mesh; pods need routable cluster networking.
2. Install a pinned Istio release, enable sidecar injection only in selected namespaces, and run `istioctl analyze`.
3. Start with permissive mTLS for migration and verify sidecar-to-sidecar and non-mesh clients. Move to strict mTLS only after traffic inventory and exceptions are resolved.
4. Install Argo Rollouts controller and kubectl plugin at a compatible pinned version.
5. Apply the three-farm manifests and inspect the Istio route weights; separately apply one Argo Rollout example and watch its pause/promotion lifecycle.
6. For Secrets Store CSI, verify the IAM trust conditions, service account identity, provider installation, and secret mount in a test pod. Never echo the mounted value to logs.
7. Observe traffic distribution, error/latency metrics, pod readiness, Envoy config, and application signals; verify rollback before increasing exposure.

## Important distinction in the canary design

The 98/1/1 Istio experiment uses three backend subsets and an explicitly authored `VirtualService`. Argo Rollouts canary steps describe one rollout's stable/canary ReplicaSets and let the traffic router adjust their weights. Combining the two concepts without a traffic-ownership design can cause both controllers to rewrite the same route. The manifests keep them separate.

## Prerequisites and safety

- EKS with a supported Kubernetes release, VPC CNI, and working CoreDNS.
- Istio control plane/data plane installed and compatible with the cluster release.
- Argo Rollouts controller installed before applying Rollout resources.
- Prometheus only if using the sample analysis template; adapt metric names to your telemetry.
- AWS Secrets Store CSI Driver plus the AWS provider, and an IAM role trust policy restricted to the test cluster/namespace/service account.

Check AWS cost and quotas before creating EKS, NAT gateways, or load balancers. Review and pin chart, controller, provider, and image versions for your environment. Never commit kubeconfigs, private keys, secret values, AWS state, or customer cluster exports.
