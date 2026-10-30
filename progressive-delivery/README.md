# Progressive Delivery Lab

Two traffic-management patterns are provided and intentionally separated:

- `istio-three-farm/` is an explicit 98/1/1 weighted route across stable, candidate, and control subsets.
- `argo-rollouts/` uses a Rollout resource to promote stable to canary or preview to active. Argo Rollouts owns the stable/canary route weights during its lifecycle.

The three-farm experiment is useful when an operational model needs a small control cohort to compare the new version against both the primary and previous code path. The Argo examples demonstrate controlled two-version promotion with pauses and an operator decision. Do not let both an operator-authored route and Argo Rollouts reconcile the same weights at the same time.
