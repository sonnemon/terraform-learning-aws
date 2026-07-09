# modules/ — Shared modules

Custom Terraform modules reused across lessons. Populated starting at **lesson 08**.

## Planned modules

- **`lambda-api/`** (lesson 08): Lambda + API Gateway + IAM role + log group.
- **`dynamodb-table/`** (lesson 08): DynamoDB table with variable validations.
- **`microservice/`** (lesson 15): ECR + task definition + Fargate service + Service Connect + logs.
- **`ai-service/`** (lesson 19): everything in microservice + Bedrock-scoped IAM. The platform engineering module.

## Convention

Each module: `main.tf`, `variables.tf` (with validations), `outputs.tf` and a short `README.md` with a usage example.
