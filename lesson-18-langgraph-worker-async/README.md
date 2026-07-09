# Lesson 18 — LangGraph Async Worker · ~$0.05/session

## Services

Brings everything together: SQS (05) + containers (11) + Bedrock (16) + RDS (17).

- **API (Lambda or Fargate):** receives the job and replies instantly with a `job_id`.
- **SQS:** queues the jobs; the agent can take minutes and nobody has to wait.
- **Worker (Fargate or Lambda):** consumes the queue and runs the LangGraph graph.
- **LangGraph checkpointer in Postgres:** the graph's state is saved in the RDS from lesson-17 → if the worker restarts, the agent resumes where it left off.
- **DynamoDB:** job status/result for polling (`PENDING → RUNNING → DONE`).
- **Bedrock:** the LLM the graph uses.

## Example project

An async research agent — the real production pattern for slow agents:

```
POST /jobs → API → SQS → worker (LangGraph + Bedrock, checkpoints in Postgres)
                              → DynamoDB (result)
GET /jobs/{id} → "DONE" + answer
```

1. API that enqueues and returns a `job_id`.
2. Worker with a 2-3 node graph (plan → research → summarize) and a Postgres checkpointer.
3. Store the result in DynamoDB and query it by id.
4. Kill the worker mid-job and verify it resumes from the checkpoint.

## What you learn

- The async pattern for agents that take minutes.
- Agents that survive restarts (checkpointing).
- Composing every piece of the repo into a real architecture.
