# Lesson 04 — API + DynamoDB · $0.00

## Services

- **DynamoDB:** serverless NoSQL database. No servers to manage, you pay per request (the free tier is plenty for learning). Tables have a partition key (and optional sort key).
- **Lambda:** the API backend, this time in Python.
- **API Gateway (HTTP API):** `POST` and `GET` routes to the Lambda.
- **IAM:** Lambda role with permissions ONLY on the table (least privilege).
- **CloudWatch Logs:** Lambda logs.

## Example project

A notes API in Python:

```
POST /notes   → Lambda → puts item into DynamoDB
GET  /notes   → Lambda → lists items from DynamoDB
```

```
app/
└── handler.py    # uses boto3 for put_item / scan
```

1. Create a DynamoDB table (`id` as partition key).
2. Python Lambda with read/write permissions on that table only.
3. POST/GET routes on API Gateway.
4. Test with `curl`: create a note, then list it.

## What you learn

- Wiring Lambda to DynamoDB (a real backend API).
- Least-privilege IAM (only that table, only those actions).
- Mixing languages: the infra stays the same even when the runtime changes.
