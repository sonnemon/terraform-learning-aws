# Lesson 14 — RDS + Secrets · ~$0.03/session

## Services

- **RDS (Postgres):** managed relational database. AWS handles backups, patches and the server. Here a `db.t3.micro`. Takes 5-10 min to create/destroy.
- **Secrets Manager:** stores secrets (passwords) encrypted, with optional rotation. Costs ~$0.40/month per secret.
- **SSM Parameter Store:** alternative for storing config/secrets. The standard tier is **free**.
- **Restrictive Security Groups:** the DB only accepts connections from the app's Security Group (Lambda/EC2), never from the internet.

## Example project

A database with properly handled credentials:

```
Lambda (app SG) → port 5432 → RDS Postgres (db SG, private subnet from 12)
                       password ← Parameter Store / Secrets Manager
```

1. Generate a random password with Terraform (`random_password`) and store it in Parameter Store.
2. Create RDS Postgres in the private subnets from lesson-12.
3. DB security group allowing 5432 only from the Lambda's security group.
4. Lambda that reads the secret, connects and runs `SELECT version()`.
5. Destroy (remember RDS takes a while to die).

## What you learn

- Never hardcode passwords.
- Why the tfstate is sensitive (the password sits there in plain text).
- DB access only from the app, enforced by Security Groups.
