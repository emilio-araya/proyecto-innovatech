# Manifiestos Kubernetes — Innovatech (Amazon EKS)

Manifiestos para desplegar la plataforma en el clúster `innovatech-eks` (us-east-1).
El pipeline de GitHub Actions los aplica con `kubectl apply -f k8s/` en la rama `deploy`.

## Estructura

| Archivo | Contenido |
|---|---|
| `namespace.yaml` | Namespace `innovatech` |
| `config.yaml` | ConfigMap (conexión MySQL) + plantilla de Secret |
| `back-ventas.yaml` | Deployment + Service ClusterIP (API Ventas, :8080) |
| `back-despachos.yaml` | Deployment + Service ClusterIP (API Despachos, :8081) |
| `front-despacho.yaml` | Deployment + Service LoadBalancer (frontend, :80) |

## Antes de aplicar (una sola vez)

1. **Reemplazar el registry de ECR** en los 3 Deployments:

   ```bash
   export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
   sed -i "s/CHANGE_ME/${ACCOUNT_ID}/" k8s/*.yaml
   ```

2. **Configurar la conexión a la base de datos** en `config.yaml` (endpoint RDS real).

3. **Crear el secreto con credenciales reales** (no commitear credenciales):

   ```bash
   kubectl create secret generic mysql-credentials \
     --from-literal=DB_USERNAME=admin \
     --from-literal=DB_PASSWORD='tu-password' \
     --namespace innovatech
   ```

## Despliegue manual

```bash
aws eks update-kubeconfig --name innovatech-eks --region us-east-1
kubectl apply -f k8s/
kubectl get all -n innovatech
```

## Diseño de red

- `front-despacho` es el **único servicio público** (LoadBalancer → ELB).
- Los backends se exponen solo como `ClusterIP`, inaccesibles desde internet (Zero Trust).
