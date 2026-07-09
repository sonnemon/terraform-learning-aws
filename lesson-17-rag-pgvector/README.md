# Lesson 17 — RAG with pgvector · ~$0.04/session

## Services

- **RDS Postgres + pgvector:** the same RDS as lesson-14 but with the `pgvector` extension enabled — Postgres storing embeddings and doing similarity search. (You already know it from Supabase: here the learning is pure Terraform/AWS.)
- **Parameter Group:** RDS configuration managed by Terraform; needed to enable extensions.
- **Bedrock (Titan/Cohere embeddings):** generates the vectors for each document. Pay per token.
- **Ingestion Lambda:** receives text → gets the embedding from Bedrock → inserts it into Postgres.
- **Search Lambda/endpoint:** hybrid search (vector + text).
- **Secrets Manager / Parameter Store + Lambda↔RDS Security Groups:** as in lesson-14.

**Deliberately avoided:** OpenSearch Serverless (high fixed minimum cost).

## Example project

A semantic document search:

```
POST /ingest { "text": "..." } → Lambda → Bedrock embedding → INSERT into pgvector
GET  /search?q=...             → Lambda → embed the query → SELECT ... ORDER BY distance
```

1. RDS with a parameter group + `CREATE EXTENSION vector`.
2. Table `documents(id, content, embedding vector(1024))`.
3. Ingest 10-20 test texts and search by meaning, not exact words.

## What you learn

- Parameter groups and extensions on RDS.
- An embeddings pipeline with Bedrock.
- Hybrid search — the foundation of any RAG.
