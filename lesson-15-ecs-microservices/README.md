# Lesson 15 — Microservices on ECS · ~$0.04/session

## Services

- **ECS Fargate (2-3 services):** several independent containers, each with its own task definition and deploy cycle.
- **ECS Service Connect:** ECS's free service discovery. Each service gets an internal DNS name (e.g. `http://users:8000`) and services talk to each other without an ALB or IPs.
- **Cloud Map namespace:** the "internal domain" where those names live (created by Service Connect).
- **IAM, Security Groups, CloudWatch Logs:** the usual, per service.

## Example project

A mini platform of 3 services:

```
gateway (public)  →  users (internal)
                  →  orders (internal)   # orders also calls users
```

1. Build a `modules/microservice` module (ECR + task + service + Service Connect + logs).
2. Deploy `users` and `orders` as internal services.
3. Public `gateway` (public IP) routing to the others by their internal DNS names.
4. Verify internal communication and service-to-service health checks.
5. Adding a fourth service = 10 lines calling the module — that's the whole point.

## What you learn

- Internal service-to-service communication (service discovery).
- Namespaces and cross-service health checks.
- Designing a reusable microservice module.
