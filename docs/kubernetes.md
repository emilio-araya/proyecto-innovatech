# Kubernetes — Amazon EKS

Manifests for the `innovatech-eks` cluster (us-east-1). The deploy workflow
applies them with `kubectl apply -f k8s/`.

## Files

| File | Contents |
|---|---|
| `backend-ventas-deployment.yaml` | Sales API, Deployment ×2 + ClusterIP Service on :8080 |
| `backend-despacho-deployment.yaml` | Shipping API, Deployment ×2 + ClusterIP Service on :8081 |
| `frontend-despacho-deployment.yaml` | Frontend, Deployment ×2 + LoadBalancer Service on :80 |
| `mysql-deployment.yaml` | MySQL Deployment with its persistent volume |
| `mysql-pvc.yaml` | PersistentVolumeClaim for MySQL data |
| `mysql-service.yaml` | Internal ClusterIP Service that the APIs use as `DB_ENDPOINT` |
| `hpa.yaml` | HorizontalPodAutoscaler for the three deployments |
| `k8s/examples/db-secret.example.yaml` | Template for the database secret (real copy is gitignored) |

All resources live in the `default` namespace and read the database
credentials from the `db-secret` Secret.

## Before the first deploy

1. **Create the database secret.** Never commit real credentials:

   ```bash
   cp k8s/examples/db-secret.example.yaml k8s/db-secret.yaml
   # edit endpoint, username and password
   kubectl apply -f k8s/db-secret.yaml
   ```

   Or create it straight from the CLI:

   ```bash
   kubectl create secret generic db-secret \
     --from-literal=endpoint=mysql-service \
     --from-literal=username=admin \
     --from-literal=password='your-password'
   ```

2. **Point the images at your own registry.** The manifests carry a placeholder
   account; the deploy workflow overrides the image of each deployment with
   `kubectl set image` on every run.

## Manual deploy

```bash
aws eks update-kubeconfig --name innovatech-eks --region us-east-1
kubectl apply -f k8s/
kubectl get pods,svc
```

## Network design

- `frontend-despacho-service` is the only public endpoint (LoadBalancer → ELB).
- Both backends are `ClusterIP`, reachable only from inside the cluster.
- MySQL is not exposed outside the cluster either.
