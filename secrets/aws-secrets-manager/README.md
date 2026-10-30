# AWS Secrets Manager via Secret Store CSI Driver

The source EKS work included integrating Secrets Manager with workloads. This pattern mounts a secret from AWS Secrets Manager through the Secrets Store CSI Driver and AWS provider, using a dedicated Kubernetes service account and EKS workload identity. Secret bytes are not committed to Git or copied into a ConfigMap.

## Setup order

1. Install the Secrets Store CSI Driver and AWS provider at pinned compatible versions.
2. Create the IAM role and trust policy in `iam/` with a condition restricted to the cluster OIDC provider and `system:serviceaccount:demo:app-secrets-reader`.
3. Grant `secretsmanager:GetSecretValue` only for the test secret path (and `kms:Decrypt` only when a customer-managed KMS key requires it).
4. Apply the service account and `SecretProviderClass`; configure the pod to mount the secret volume.
5. Verify the pod identity and mount status without printing secret contents. Confirm the application reload/rotation behavior before relying on rotation.

## Secret rotation

CSI-mounted files are refreshed only when rotation polling is enabled and supported by the installed driver version. Applications must re-read the file or restart safely. Do not assume environment variables update after rotation. Validate rotation and revocation in a test namespace.

All ARNs, regions, names, account IDs, and OIDC values in these examples are placeholders. They do not include a secret value.
