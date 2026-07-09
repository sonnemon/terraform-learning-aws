# Lesson 11 — ECR + Fargate · ~$0.02/session

## Services

- **ECR (Elastic Container Registry):** private Docker image registry, like Docker Hub but inside your account.
- **ECS Cluster:** logical grouping where containers run.
- **Task Definition:** AWS's "docker-compose": which image, how much CPU/memory, environment variables, logs.
- **ECS Service (Fargate):** keeps N copies of the task running. Fargate = serverless, AWS provides the machine.
- **IAM (2 roles):** *execution role* (for ECS to pull the image and write logs) vs *task role* (what your app can do in AWS).
- **Security Group + CloudWatch Logs.**

## Example project

A containerized API, deployed by CI:

```
git push → Actions (OIDC from 07) → docker build → push to ECR (tag = commit SHA)
        → update the ECS Service → Fargate runs the container with a public IP
```

1. Minimal app (e.g. FastAPI with `GET /health`) + Dockerfile.
2. Create ECR with a lifecycle policy (clean up old images).
3. Cluster + task definition + service with `assign_public_ip = true` (NO ALB, public subnet — avoids NAT/endpoints).
4. Pipeline: build → push → deploy.
5. Test with `curl http://<ip>:8000/health` and destroy.

## What you learn

- Private registry and deploying containers without servers.
- Execution role vs task role.
- docker build → push → deploy pipeline with per-commit tags.
