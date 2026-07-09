# Lesson 10 — EventBridge Scheduler · $0.00

## Services

- **EventBridge Scheduler:** AWS's "cron". Runs something on a schedule (`cron(0 9 * * ? *)`) or every X time, with no servers.
- **Lambda:** the code that runs on each scheduler tick.
- **SNS (Simple Notification Service):** pub/sub notification service. Here: a topic with an email subscription to alert you.
- **IAM:** the scheduler needs a role to invoke the Lambda; the Lambda needs another to publish to SNS.

## Example project

A daily cost alert — protects your budget while you learn:

```
cron 9:00 AM → Scheduler → Lambda → queries Cost Explorer / lists resources
                                  → SNS → email: "Month-to-date spend: $0.43"
```

1. Create the SNS topic and subscribe your email (confirm the message).
2. Lambda that queries month-to-date spend (or lists orphaned resources: loose EIPs, running instances).
3. Schedule with a cron expression that fires the Lambda every morning.
4. Receive the first email and leave it running — this lesson CAN stay alive (it's free).

## What you learn

- Scheduled tasks with cron in the cloud.
- Notifications with SNS.
- A genuinely useful case: watching your own account.
