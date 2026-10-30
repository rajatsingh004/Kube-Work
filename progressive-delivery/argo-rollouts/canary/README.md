# Argo Rollouts Canary with Istio

This adapts the source experiment using an Argo Rollout, stable/canary Services, and an Istio VirtualService. Argo Rollouts adjusts the VirtualService weights as each step advances. The rollout pauses at small traffic shares to allow inspection before exposure increases.

```sh
kubectl apply -f services-and-route.yaml
kubectl apply -f rollout.yaml
kubectl argo rollouts get rollout rollout-demo --watch -n demo
```

Change the image in the Rollout template to trigger a new ReplicaSet. Use `kubectl argo rollouts promote rollout-demo -n demo` to continue from an indefinite pause; use `kubectl argo rollouts abort rollout-demo -n demo` to abort a bad candidate. Confirm the VirtualService route and mesh metrics at each stage.

The sample route is mesh-internal. Add an ingress gateway deliberately if you want external traffic. Validate that the caller and both versions are in the mesh; traffic from excluded pods bypasses Istio routing.
