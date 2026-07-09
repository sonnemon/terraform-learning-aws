# Lesson 16 — Bedrock Agent API · ~$0.05/session

## Services

- **Amazon Bedrock:** access to AI models (Claude, Nova, Titan...) through an AWS API. Pay per token, **no fixed cost**. The big advantage: authorization is pure IAM, no external API keys to store/rotate.
- **Fargate:** the container running the agent (Python + LangGraph).
- **Scoped IAM task role:** the container's role allows `bedrock:InvokeModel` ONLY on the specific models you use (Haiku/Nova for testing).
- **ECR + CloudWatch Logs:** image and logs, as in lesson-11.

**One-time setup (free):** enable model access in the Bedrock console.

## Example project

A chat API with an agent:

```
POST /chat { "message": "..." } → Fargate (LangGraph) → Bedrock (Haiku) → streamed response
```

1. Python app: FastAPI + LangGraph with a simple agent (one node calling Bedrock).
2. Task role with `InvokeModel` restricted to the model's ARN.
3. Deploy on Fargate reusing what you learned in 11/15.
4. Test with `curl`, watch the token streaming, and destroy.

## What you learn

- IAM scoped to specific models.
- Task role for invoking Bedrock (zero secrets).
- Streaming LLM responses in production.
