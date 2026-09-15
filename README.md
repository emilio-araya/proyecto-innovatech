# 🚀 Innovatech Chile | Plataforma Cloud-Native en AWS

Proyecto académico de Duoc UC orientado a una arquitectura de microservicios con Spring Boot, React, Docker, Kubernetes y automatización CI/CD sobre AWS.

## 🧭 Arquitectura

Flujo de despliegue:

GitHub → GitHub Actions → Docker → Amazon ECR → Amazon EKS

El repositorio mantiene tres componentes principales:

- **Frontend:** React + Vite + Nginx
- **Backend Ventas:** Spring Boot, puerto 8080
- **Backend Despachos:** Spring Boot, puerto 8081

Los backends se exponen internamente mediante Services `ClusterIP` y el frontend mediante un `LoadBalancer`.

## ☁️ AWS y Kubernetes

La configuración está preparada para Amazon EKS y Amazon ECR en `us-east-1`. El nombre del clúster se obtiene mediante el secret `EKS_CLUSTER_NAME`.

La infraestructura Kubernetes incluida en `k8s/` también contiene un **MySQL 8 de prueba** con almacenamiento persistente de 5 GiB. Esta base de datos forma parte del entorno académico/test y no debe interpretarse como una configuración de producción con RDS.

## ⚙️ CI/CD

El workflow `.github/workflows/ci-cd.yml` se ejecuta automáticamente cuando se realiza un push a la rama **`deploy`**.

El pipeline:

1. Descarga el código.
2. Configura credenciales AWS mediante GitHub Secrets.
3. Inicia sesión en Amazon ECR.
4. Construye y publica las imágenes de frontend, ventas y despachos.
5. Configura `kubectl` para EKS.
6. Aplica los manifiestos de `k8s/`.
7. Actualiza las imágenes con el número de ejecución de GitHub Actions.
8. Espera la finalización de los Rolling Updates.
9. Verifica Pods y Services.

## 🐳 Contenedores

Los tres componentes utilizan Docker multi-stage builds:

- Frontend: Node 20 para compilación + Nginx Alpine para ejecución.
- Ventas: Maven + Eclipse Temurin 17.
- Despachos: Maven + Eclipse Temurin 17.

Las imágenes se publican en Amazon ECR con etiquetas `latest` y el número de ejecución del workflow.

## 📈 Escalabilidad

Los backends cuentan con Horizontal Pod Autoscaler (`autoscaling/v2`):

- Mínimo: 2 réplicas
- Máximo: 6 réplicas
- Objetivo de CPU: 70%

## 🔐 Configuración y seguridad

Las credenciales reales de AWS deben almacenarse exclusivamente en **GitHub Actions Secrets**. La plantilla `.github/secrets-template.md` documenta los nombres esperados.

`k8s/db-secret.yaml` contiene credenciales **de prueba** para el MySQL incluido en Kubernetes. No utilizar estos valores en producción.

El proyecto no requiere credenciales Docker Hub ni llaves SSH para su workflow actual: utiliza ECR/EKS y las credenciales AWS configuradas como Secrets.

## 📂 Estructura

```text
.
├── .github/
│   ├── secrets-template.md
│   └── workflows/
├── k8s/
│   ├── backend-despacho-deployment.yaml
│   ├── backend-ventas-deployment.yaml
│   ├── db-secret.yaml
│   ├── frontend-despacho-deployment.yaml
│   ├── hpa.yaml
│   ├── mysql-deployment.yaml
│   ├── mysql-pvc.yaml
│   └── mysql-service.yaml
├── back-Ventas_SpringBoot/
├── back-Despachos_SpringBoot/
├── front_despacho/
└── README.md
```

## 🧪 Validación

Comandos útiles dentro del clúster:

```bash
kubectl get pods
kubectl get services
kubectl get deployments
kubectl get hpa
kubectl top pods
```

## 🔮 Mejoras futuras

Las siguientes mejoras quedan como trabajo futuro y no forman parte de la implementación académica aprobada:

- **Parametrizar el registro de Amazon ECR:** actualmente los manifiestos Kubernetes utilizan directamente el registro ECR asociado al proyecto. En una evolución futura se podría parametrizar la cuenta, región y nombres de repositorio para facilitar la reutilización en otros entornos.
- **Gestión externa de secretos:** reemplazar las credenciales de prueba de Kubernetes por un sistema de gestión de secretos como AWS Secrets Manager o External Secrets en un entorno productivo.
- **Separación de entornos:** incorporar configuraciones independientes para desarrollo, staging y producción mediante overlays o una estrategia equivalente.
- **Imágenes inmutables:** priorizar referencias por digest o una estrategia de versionado estricta en lugar de depender de la etiqueta `latest`.
- **Hardening de producción:** incorporar controles adicionales de seguridad, observabilidad y políticas de recursos antes de utilizar la arquitectura fuera del contexto académico.

Estas mejoras permitirían llevar el proyecto desde su escenario académico actual hacia una implementación más preparada para producción, sin alterar la arquitectura que fue utilizada y aprobada para el proyecto final.

## 👥 Equipo

- Benjamin Serrano
- Emilio Araya
- Luis Villalobos

## 📄 Licencia

Proyecto académico desarrollado en Duoc UC con fines educativos.
