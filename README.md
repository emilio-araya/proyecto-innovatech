# Innovatech Chile — Microservicios en Amazon EKS

[![CI](https://github.com/emilio-araya/proyecto-innovatech/actions/workflows/ci.yml/badge.svg)](https://github.com/emilio-araya/proyecto-innovatech/actions/workflows/ci.yml)

Proyecto semestral de la asignatura de DevOps (Duoc UC), desarrollado en equipo. Una tienda con dos APIs Spring Boot (ventas y despachos) y un frontend React, empaquetados con Docker, publicados en Amazon ECR y desplegados en Amazon EKS mediante GitHub Actions.

Este repositorio reúne el trabajo del equipo y las mejoras que mantengo: el pipeline, los manifiestos de Kubernetes, los Dockerfiles y la integración de las ramas de desarrollo e infraestructura en `main`. El repositorio original del equipo es [bencasolocaso/proyecto-semestral-devops](https://github.com/bencasolocaso/proyecto-semestral-devops).

## Arquitectura

```text
Terraform ──► VPC · subredes · EKS · IAM

GitHub Actions ──► Docker build (multi-stage) ──► Amazon ECR ──► kubectl apply ──► Amazon EKS

EKS (namespace default)
├── frontend-despacho   Deployment ×2 · Service LoadBalancer (público, :80)
├── backend-ventas      Deployment ×2 · Service ClusterIP (interno, :8080)
├── backend-despachos   Deployment ×2 · Service ClusterIP (interno, :8081)
└── mysql               Deployment ×1 · Service ClusterIP + PVC
                          │
                          ▼
                    Amazon RDS (MySQL)
```

Solo el frontend se expone a Internet; las APIs y la base de datos son internas al clúster.

## Mi aporte

- **Pipeline CI/CD** ([`ci.yml`](.github/workflows/ci.yml), [`ci-cd.yml`](.github/workflows/ci-cd.yml)): compila las dos APIs y corre sus tests contra MySQL en cada push y pull request. El despliegue corre los tests primero, publica las tres imágenes en ECR y aplica un rolling update verificando `kubectl rollout status`.
- **Kubernetes y Docker**: Dockerfiles multi-stage de las tres aplicaciones y manifiestos de [`k8s/`](k8s) (Deployments, Services, HPA, MySQL con volumen persistente y plantilla de secreto).
- **Backend**: mejoré la validación y la persistencia de los controladores de Ventas y Despachos, pasé a inyección por constructor y externalicé la configuración de la base de datos.
- **Integración**: uní las ramas `deploy` e `infrastructure/terraform` en `main`, eliminé el workflow duplicado y saqué las credenciales de la base de datos del repositorio.
- **Documentación** del proyecto y de los manifiestos ([`docs/kubernetes.md`](docs/kubernetes.md)).

La infraestructura del clúster con Terraform (VPC, EKS, IAM) la escribió Luis Villalobos.

## Estructura

```text
.
├── .github/workflows/ci.yml        Tests de las dos APIs contra MySQL
├── .github/workflows/ci-cd.yml     Despliegue manual a EKS (corre los tests primero)
├── back-Ventas_SpringBoot/         API de ventas (Spring Boot 3, Java 17)
├── back-Despachos_SpringBoot/      API de despachos (Spring Boot 3, Java 17)
├── front_despacho/                 Frontend (React 18 + Vite + Tailwind)
├── k8s/                            Manifiestos de Kubernetes
├── terraform/                      VPC, EKS e IAM
└── docs/                           Documentación de despliegue
```

## Infraestructura

[`terraform/`](terraform) crea la VPC, las subredes, el clúster de EKS, los roles de IAM y los addons. Antes de aplicarla hay que completar `terraform.tfvars` a partir de [`terraform.tfvars.example`](terraform/terraform.tfvars.example):

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Cómo se ejecuta

El workflow [`ci.yml`](.github/workflows/ci.yml) compila las dos APIs y corre sus tests contra MySQL en cada push y pull request.

El despliegue es manual, desde **Actions → Deploy to Amazon EKS → Run workflow**. Antes de construir las imágenes ejecuta los mismos tests, y requiere un clúster `innovatech-eks` en `us-east-1` y los secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` y `EKS_CLUSTER_NAME`.

Para desplegar a mano, los pasos previos (registry de ECR, endpoint de la base y secreto con las credenciales) están en [`docs/kubernetes.md`](docs/kubernetes.md):

```bash
aws eks update-kubeconfig --name innovatech-eks --region us-east-1
kubectl apply -f k8s/
kubectl get pods,svc
```

Para correr una API en local se necesita una base MySQL y las variables `DB_ENDPOINT`, `DB_PORT`, `DB_NAME`, `DB_USERNAME` y `DB_PASSWORD`:

```bash
cd back-Ventas_SpringBoot/Springboot-API-REST
./mvnw spring-boot:run
```

## Limitaciones

- El clúster se creó en un laboratorio de AWS con credenciales temporales. Fuera de ese entorno el despliegue no puede autenticarse ni encontrar el clúster, y por eso es manual: no se ejecuta en cada push.
- El frontend no tiene tests automatizados; la cobertura de CI se limita a las dos APIs.
- El despliegue es HTTP sin TLS ni dominio propio.

## Equipo

Benjamín Serrano · Emilio Araya · Luis Villalobos
