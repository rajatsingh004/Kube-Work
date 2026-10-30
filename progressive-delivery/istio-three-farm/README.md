# Istio Three-Farm Canary Split

This reproduces the source traffic experiment as three independently deployed subsets: 98% stable, 1% candidate, and 1% control. A single Kubernetes Service selects all pods, while Istio's `DestinationRule` labels identify the three subsets and the `VirtualService` sends explicit weights.

```sh
kubectl apply -f deployments.yaml
kubectl apply -f destination-rule.yaml
kubectl apply -f virtual-service.yaml
kubectl get virtualservice,destinationrule -n demo
```

Inspect route configuration and request counts in the mesh telemetry to confirm the split. Request volume is stochastic; a tiny one-percent share needs enough total requests to assess. Use real success/error/latency signals and define stop conditions before production.

This is not managed by Argo Rollouts. Change weights through a reviewed route update, and avoid installing a Rollout controller for this same route unless ownership is redesigned.
