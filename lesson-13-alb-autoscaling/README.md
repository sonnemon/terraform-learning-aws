# Lesson 13 — ALB + Auto Scaling · ~$0.05/session

## Services

- **ALB (Application Load Balancer):** distributes HTTP traffic across multiple instances. Bills ~$0.025/h — cheap per session, expensive when forgotten ($16/month).
- **Target Group:** the list of instances the ALB sends traffic to, with health checks (an unhealthy one stops receiving traffic).
- **Launch Template:** instance blueprint (AMI, type, user data) the ASG uses to create identical copies.
- **Auto Scaling Group (ASG):** keeps N instances alive. If one dies, it replaces it; under load, it scales out.

## Example project

Classic end-to-end traffic with self-healing:

```
Internet → ALB → Target Group → ASG (2x EC2 with nginx, in the VPC from 12)
```

1. Launch template with nginx serving the instance's hostname.
2. ASG with min=2, max=4 across the public subnets from lesson-12.
3. ALB + target group with a health check on `/`.
4. Refresh the browser and watch the hostnames alternate.
5. **Kill an instance by hand** and watch the ASG replace it.
6. Destroy immediately when done (the ALB bills by the hour).

## What you learn

- Load balancing and health checks.
- Scaling policies and self-healing.
- The classic pre-containers pattern that still runs half the internet.
