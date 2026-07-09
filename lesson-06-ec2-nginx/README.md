# Lesson 06 — EC2 + Nginx · ~$0.01/session

## Services

- **EC2:** AWS virtual machines. Here a `t3.micro` (the small, cheap one).
- **Security Group:** the instance's firewall. Defines which ports are open in/out (here: only 80).
- **SSM Session Manager:** shell access to the instance WITHOUT opening port 22 or managing SSH keys. Only needs an IAM role and the agent (preinstalled on Amazon Linux).
- **User Data:** script that runs when the instance boots (here: install nginx).
- **Default VPC:** the network AWS gives you out of the box; used as-is in this lesson.

## Example project

A classic web server:

```
Internet → port 80 → EC2 (nginx) → "Hello from EC2"
```

1. Create a Security Group allowing inbound only on port 80.
2. Launch a `t3.micro` with User Data that installs nginx and writes an index.html.
3. IAM role with the SSM policy so you can connect via `aws ssm start-session`.
4. Output the public IP → open it in the browser.
5. **Destroy when done** — this one bills by the hour.

## What you learn

- Creating a VM with IaC.
- Opening ports with Security Groups.
- Connecting without SSH or key pairs (SSM).
- Destroy discipline for hourly-billed resources.
