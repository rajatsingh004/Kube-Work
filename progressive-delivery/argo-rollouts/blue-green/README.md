# Argo Rollouts Blue/Green

This reproduces the source blue/green workflow: the active version serves traffic while a preview ReplicaSet is brought up, health-checked, and promoted only after explicit approval. The stable active service remains available until promotion.

```sh
kubectl apply -f services.yaml
kubectl apply -f rollout.yaml
kubectl argo rollouts get rollout rollout-bluegreen --watch -n demo
# Validate the preview before promotion:
kubectl argo rollouts promote rollout-bluegreen -n demo
```

Abort the rollout if preview checks fail. Define the observation window, service health criteria, and scale-down delay to suit session/drain behavior. Kubernetes readiness alone does not prove application correctness.
