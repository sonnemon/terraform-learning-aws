# Lesson 05 — SQS Worker + DLQ · $0.00

## Services

- **SQS (Simple Queue Service):** message queue. A producer drops messages, a consumer processes them when it can. Decouples the API from heavy work.
- **DLQ (Dead Letter Queue):** another SQS queue where messages that failed too many times land, so you can inspect them without losing them.
- **Lambda (x2):** a "producer" (receives the request and enqueues) and a "worker" (processes each message from the queue).
- **DynamoDB:** where the worker stores the processing result.
- **IAM + CloudWatch Logs:** permissions and logs for both Lambdas.

## Example project

An async order processor:

```
POST /orders → Lambda producer → SQS → Lambda worker → DynamoDB
                                  └── (after 3 failures) → DLQ
```

1. Create the SQS queue + DLQ with `maxReceiveCount = 3`.
2. Producer: receives the POST and calls `send_message`.
3. Worker: triggered by an event source mapping from SQS, writes to DynamoDB.
4. Test the happy path, then force an error (malformed message) and watch it land in the DLQ.

## What you learn

- Event-driven architecture and async processing.
- Retries and Dead Letter Queues.
- Separating the API from heavy processing.
