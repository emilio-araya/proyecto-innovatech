# Innovatech Chile — Microservicios en Amazon EKS

Proyecto semestral de la asignatura de DevOps (Duoc UC), desarrollado en equipo. Una tienda con dos APIs Spring Boot (ventas y despachos) y un frontend React, empaquetados con Docker, publicados en Amazon ECR y desplegados en Amazon EKS mediante GitHub Actions.

Repositorio original del equipo: [bencasolocaso/proyecto-semestral-devops](https://github.com/bencasolocaso/proyecto-semestral-devops). Esta es mi copia, donde mantengo y documento mi parte.

## Arquitectura

```text
GitHub Actions ──► Docker build (multi-stage) ──► Amazon ECR ──► kubectl apply ──► Amazon EKS

EKS (namespace innovatech)
├── front-despacho   Deployment ×2 · Service LoadBalancer (público)
├── back-ventas      Deployment ×2 · Service ClusterIP (interno, :8080)
└── back-despachos   Deployment ×2 · Service ClusterIP (interno, :8081)
                          │
                          ▼
                     MySQL (Amazon RDS)
```

Solo el frontend se expone a Internet; las APIs son internas al clúster.

## Mi aporte

- **Pipeline CI/CD** ([`.github/workflows/workflow.yml`](.github/workflows/workflow.yml)): pasé el despliegue a Amazon EKS y agregué la construcción y publicación en ECR de las tres imágenes, etiquetadas con `latest` y el SHA del commit.
- **Kubernetes y Docker**: Dockerfiles multi-stage de las tres aplicaciones y manifiestos de [`k8s/`](k8s) (namespace, Deployments, Services, ConfigMap y plantilla de Secret).
- **Backend**: en la rama [`deploy`](https://github.com/emilio-araya/proyecto-innovatech/tree/deploy) mejoré la validación y la persistencia de los controladores de Ventas y Despachos, pasé a inyección por constructor y externalicé la configuración de la base de datos.
- **Documentación** del proyecto.

La infraestructura del clúster con Terraform (VPC, EKS, IAM) la escribió Luis Villalobos y está en la rama [`infrastructure/terraform`](https://github.com/emilio-araya/proyecto-innovatech/tree/infrastructure/terraform).

## Estructura

```text
.
├── .github/workflows/workflow.yml   Pipeline build → ECR → EKS
├── back-Ventas_SpringBoot/          API de ventas (Spring Boot 3, Java 17)
├── back-Despachos_SpringBoot/       API de despachos (Spring Boot 3, Java 17)
├── front_despacho/                  Frontend (React 18 + Vite + Tailwind)
└── k8s/                             Manifiestos de Kubernetes
```

## Cómo se ejecuta

El pipeline se dispara con un push a la rama `deploy`. Requiere un clúster `innovatech-eks` en `us-east-1` y los secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` y `AWS_SESSION_TOKEN`.

Para desplegar a mano, los pasos previos (registry de ECR, endpoint de RDS y secreto con las credenciales) están en [`k8s/README.md`](k8s/README.md):

```bash
aws eks update-kubeconfig --name innovatech-eks --region us-east-1
kubectl apply -f k8s/
kubectl get pods,svc -n innovatech
```

Para correr una API en local se necesita una base MySQL y las variables `DB_ENDPOINT`, `DB_PORT`, `DB_NAME`, `DB_USERNAME` y `DB_PASSWORD`:

```bash
cd back-Ventas_SpringBoot/Springboot-API-REST
./mvnw spring-boot:run
```

## Limitaciones

- El clúster se creó en un laboratorio de AWS con credenciales temporales. Fuera de ese entorno el pipeline no puede autenticarse ni encontrar el clúster, y por eso fallan sus ejecuciones recientes.
- El pipeline no ejecuta tests antes de construir las imágenes.
- Los cambios de las ramas `deploy` e `infrastructure/terraform` aún no están integrados en `main`.

## Equipo

Benjamín Serrano · Emilio Araya · Luis Villalobos
