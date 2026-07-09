# Lesson 03 — Lambda API · $0.00

## Services

- **Lambda:** runs your code without servers. You upload a function (zip), AWS runs it when something invokes it, and you only pay per execution.
- **API Gateway (HTTP API):** HTTP front door. Receives requests from the internet and forwards them to the Lambda. The "HTTP API" flavor is the simple, cheap one.
- **IAM Role/Policy:** the Lambda needs a role that says what it's allowed to do (at minimum: write logs).
- **CloudWatch Logs:** where the Lambda's `console.log` output ends up. The log group is declared with 7-day retention.

## Example project

A "hello world" API in Node/TypeScript:

```
GET /hello  →  API Gateway  →  Lambda  →  { "message": "hello from lambda" }
```

```
src/
└── index.ts    # handler that returns JSON
```

1. Write the handler and package it as a zip.
2. Create Lambda + IAM role + log group.
3. Create the HTTP API and wire it to the Lambda.
4. Output the URL → test with `curl`.

## What you learn

- Creating a Lambda with Terraform (runtime + zip).
- Exposing it over HTTP.
- Proper IAM (execution role, invoke permission).
- Reading logs in CloudWatch.
