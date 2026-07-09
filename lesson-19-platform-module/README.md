# Lesson 19 — Platform Module · $0.00

## Services

No new resources: this is a refactor. Everything that already exists (ECR, Fargate, Bedrock IAM, logs, Service Connect) gets packaged into a single module.

- **`modules/ai-service`:** a module that takes "service name + image + allowed Bedrock models" and creates EVERYTHING needed to run an AI service.

## Example project

Shipping a new AI product = a 15-line file + a PR:

```hcl
module "support_chatbot" {
  source         = "../modules/ai-service"
  name           = "support-chatbot"
  image_tag      = "abc1234"
  bedrock_models = ["anthropic.claude-haiku-*"]
  cpu            = 256
  memory         = 512
}
```

1. Design the module's interface: which variables it exposes, what it decides for the developer (7-day logs, tags, Service Connect, scoped IAM — all baked in).
2. Migrate the lesson-16 service to the module.
3. Create a second service with just the block above and watch the pipeline from 07 do the rest.

## What you learn

- Platform engineering: you don't just deploy — you build the platform so every developer can deploy on their own.
- Module interface design (what to expose, what to hide).
- The portfolio's closing message.
