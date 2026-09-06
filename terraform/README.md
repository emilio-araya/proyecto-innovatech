# Terraform - Infraestructura EKS para Innovatech

## Descripción

Esta configuración de Terraform despliega un clúster **Amazon EKS (Elastic Kubernetes Service)** completamente funcional con:

- ✅ VPC con subredes públicas y privadas (2 AZs)
- ✅ NAT Gateways para salida de datos desde subredes privadas
- ✅ Clúster EKS con logging habilitado
- ✅ Node Group con auto-scaling
- ✅ Roles IAM con permisos adecuados
- ✅ OIDC Provider para IRSA (IAM Roles for Service Accounts)
- ✅ Metrics Server (requerido para HPA)
- ✅ Cluster Autoscaler
- ✅ AWS Load Balancer Controller
- ✅ Security Groups con políticas restrictivas

## Requisitos previos

1. **AWS Account** con acceso a AWS Academy Learner Lab
2. **Terraform** >= 1.0
   ```bash
   terraform version
   ```

3. **AWS CLI** configurado
   ```bash
   aws configure
   ```

4. **kubectl** instalado
   ```bash
   kubectl version --client
   ```

5. **Helm** instalado
   ```bash
   helm version
   ```

## Estructura de archivos

```
terraform/
├── providers.tf              # Configuración de proveedores
├── variables.tf              # Variables de entrada
├── terraform.tfvars.example  # Ejemplo de valores
├── vpc.tf                    # VPC, subredes, NAT, security groups
├── iam.tf                    # Roles y políticas IAM
├── eks.tf                    # Clúster EKS y node groups
├── addons.tf                 # Add-ons: Metrics Server, Cluster Autoscaler, ALB Controller
├── outputs.tf                # Outputs principales
├── backend.tf                # Configuración de backend remoto (opcional)
└── README.md                 # Este archivo
```

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/bencasolocaso/proyecto-semestral-devops.git
cd proyecto-semestral-devops/terraform
```

### 2. Checkout a la rama de infraestructura

```bash
git checkout infrastructure/terraform
```

### 3. Configurar variables

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edita `terraform.tfvars` con tus valores:

```hcl
aws_region                = "us-east-1"
cluster_name             = "innovatech-eks-cluster"
node_group_desired_size  = 3
node_instance_type       = "t3.medium"
kubernetes_version       = "1.28"
```

### 4. Inicializar Terraform

```bash
terraform init
```

### 5. Revisar plan

```bash
terraform plan -out=tfplan
```

Esto mostrará todos los recursos que serán creados. Revisa cuidadosamente.

### 6. Aplicar configuración

```bash
terraform apply tfplan
```

⏳ **Tiempo estimado: 15-20 minutos**

### 7. Guardar outputs

```bash
terraform output > outputs.json
```

## Configurar kubectl

Una vez que el clúster esté listo:

```bash
aws eks update-kubeconfig --name innovatech-eks-cluster --region us-east-1
```

Verificar conexión:

```bash
kubectl get nodes
kubectl get pods -A
```

## Verificar add-ons

```bash
# Metrics Server
kubectl get deployment -n kube-system metrics-server

# Cluster Autoscaler
kubectl get deployment -n kube-system cluster-autoscaler

# AWS Load Balancer Controller
kubectl get deployment -n kube-system aws-load-balancer-controller
```

## Costos estimados

- **Clúster EKS**: $0.10/hora
- **3 nodos t3.medium**: ~$0.30/hora
- **NAT Gateways (2)**: $0.32/hora
- **Total**: ~$0.72/hora = ~$520/mes

⚠️ **Recuerda**: AWS Academy te proporciona crédito limitado. Destruye la infraestructura cuando no la uses.

## Destruir infraestructura

```bash
terraform destroy
```

**Esto eliminará**:
- ✅ Clúster EKS
- ✅ Node Groups
- ✅ VPC y subredes
- ✅ NAT Gateways
- ✅ Security Groups
- ✅ Roles IAM

## Troubleshooting

### Error: "AccessDenied"

- Verifica que tu sesión AWS Academy siga activa
- Recarga las credenciales: `aws configure`

### Clúster tarda mucho en crear

- Es normal, puede tomar 15-20 minutos
- Monitorea en la consola de AWS → EKS → Clusters

### Nodos no inician

```bash
kubectl describe nodes
kubectl logs -n kube-system
```

### No puedo acceder al clúster

```bash
# Reconfigura kubeconfig
rm ~/.kube/config
aws eks update-kubeconfig --name innovatech-eks-cluster --region us-east-1
```

## Pasos siguientes

1. ✅ **Desplegar Frontend y Backend**
   ```bash
   kubectl apply -f ../k8s/
   ```

2. ✅ **Configurar Ingress con ALB**
   
3. ✅ **Setupear GitHub Actions Pipeline**

4. ✅ **Configurar CloudWatch Logs**

## Referencias

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)

## Autores

- Proyecto Semestral DevOps - Innovatech Chile
- Dupla: [Tu nombre y compañeros]

## Licencia

MIT
