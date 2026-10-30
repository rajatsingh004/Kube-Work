# EKS and Istio Operational Notes

## Networking and mesh readiness

- Confirm VPC CNI health, pod IP assignment, subnet address capacity, and security-group rules before debugging mesh routing.
- Use `istioctl analyze` after applying mesh resources. Confirm destination hostnames, service ports, subset selectors, and sidecar injection.
- Istio mTLS permissive mode accepts mesh and non-mesh traffic. Inventory callers and exceptions before moving to strict mode; strict mTLS will reject clients that do not present mesh identity.
- Validate from an in-cluster client pod. Envoy listener sockets bind to the pod network namespace; a `kubectl port-forward` to a listener port may not exercise the intended network path.

## Rollout verification

For an Istio route, inspect `kubectl get virtualservice,destinationrule -n demo -o yaml` and the proxy config dump. Check that all route weights sum to 100 and that subsets match pod labels. For Argo Rollouts, inspect `kubectl argo rollouts get rollout <name> -n demo --watch`, ReplicaSet readiness, service selectors, pause status, and abort conditions.

## Security and recovery

- Keep Secrets Manager access scoped to the workload role and one secret path.
- Verify service account OIDC trust conditions; never use node-role access for app secrets.
- Confirm deployment rollback returns both the Rollout revision and Istio route to a known healthy state.
- Use PodDisruptionBudgets and enough multi-AZ capacity; they do not ensure that a new version is healthy.

## Example inspection commands

```sh
kubectl get gateway,httproute,virtualservice,destinationrule,rollout -A
kubectl describe rollout rollout-demo -n demo
kubectl logs -n istio-system deploy/istiod
kubectl logs -n demo <pod> -c istio-proxy
kubectl -n demo exec <client-pod> -- wget -qO- http://demo-farms:8080/
```
