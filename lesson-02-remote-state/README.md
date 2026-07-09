# Lesson 02 — Remote State · $0.00

## Services

- **S3:** stores the Terraform state file (`terraform.tfstate`) instead of keeping it on your disk. It doesn't get lost and can be shared.
- **DynamoDB:** AWS's NoSQL database. Used here only for "state locking": a table that prevents two people/processes from running `apply` at the same time.
- **IAM (optional):** minimal permissions to access the state bucket.

## Example project

The backend the whole repo will use:

1. Create an S3 bucket with versioning enabled (state history).
2. Create a DynamoDB table with a `LockID` key.
3. Migrate lesson-01's state from local disk to this backend (`terraform init -migrate-state`).
4. Every future lesson uses its own key: `key = "lesson-NN/terraform.tfstate"`.

```
S3 bucket (states)
├── lesson-01/terraform.tfstate
├── lesson-03/terraform.tfstate
└── ...
```

## What you learn

- What the state is and why it's sensitive (it stores everything in plain text).
- Remote state and state locking.
- Migrating an existing state (real-world exercise).
- Separating states per project.
