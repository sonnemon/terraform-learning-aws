# Lesson 20 (optional) — CDK Comparison

## Services

Same as lesson-04 (Lambda, API Gateway, DynamoDB, IAM, CloudWatch Logs). What changes is the tool:

- **AWS CDK:** infrastructure written in a real programming language (here TypeScript). It compiles to CloudFormation, AWS's native IaC engine.
- **CloudFormation:** the AWS service that executes what CDK generates (the equivalent of Terraform's state + apply, but managed by AWS).

## Example project

Rewrite the notes API from lesson-04 in CDK:

```
lib/
└── notes-api-stack.ts   # table + Lambda + API in TypeScript

cdk deploy   →  same result as terraform apply in lesson-04
```

1. `cdk init app --language typescript`.
2. Define the DynamoDB table, Lambda and HTTP API with CDK constructs.
3. Deploy, test with `curl`, compare side by side with the Terraform version.
4. Write the honest comparison in this README: where CDK is nicer (permissions via `table.grantReadWriteData(fn)`) and where Terraform wins (multi-cloud, ecosystem, explicit plan).

## What you learn

- The second portfolio data point: "I know Terraform AND CDK, and when to use each" — a great interview answer.
- One afternoon of work.

*(Serverless Framework: ruled out — it overlaps with Terraform and lost traction since the v4 paid license.)*
