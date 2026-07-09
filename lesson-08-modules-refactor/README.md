# Lesson 08 — Modules (refactor) · $0.00

## Services

Same as lesson-04 (Lambda, API Gateway, DynamoDB, IAM, CloudWatch Logs). No new services: this lesson is about **Terraform**, not AWS.

- **Terraform module:** a reusable folder with `variables` (inputs), resources and `outputs`. Like a function, but for infrastructure.

## Example project

Refactor the notes API from lesson-04 using your own modules:

```
modules/
├── lambda-api/        # Lambda + API Gateway + role + logs
└── dynamodb-table/    # table with validations

lesson-08-modules-refactor/
└── main.tf            # just calls the modules (~20 lines)
```

1. Extract `modules/lambda-api` and `modules/dynamodb-table`.
2. Add variable validations (e.g. table name format).
3. Rewrite lesson-04 by calling the modules.
4. Use `for_each` to create multiple routes/tables without copy-pasting.

## What you learn

- Writing your own modules with variables, validations and outputs.
- `for_each` / `count`.
- Versioning and reuse — the foundation for the rest of the repo.
