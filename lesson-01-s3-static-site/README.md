# Lesson 01 — S3 Static Site · $0.00

## Services

- **S3 (Simple Storage Service):** object (file) storage. Files live in "buckets" with globally unique names. Can serve static websites directly.
- **Bucket Policy:** JSON document attached to the bucket that defines who can do what (e.g. allow public read of the objects).
- **Public Access Block:** security switch that blocks public access to a bucket. Enabled by default; you have to disable it on purpose for a public site.
- **IAM Policy (optional):** permissions for AWS users/roles (who manages the bucket).

## Example project

A simple cat page:

```
src/
├── index.html    # "Hi, I'm a Cat"
└── error.html    # 404 page
```

1. Create an S3 bucket with static hosting enabled.
2. Disable the Public Access Block and attach a public-read Bucket Policy.
3. Upload `index.html` and `error.html`.
4. Output the site URL → open it in the browser.
5. Destroy everything when done.

## What you learn

- Creating buckets and static hosting with IaC.
- Basic permissions (policy vs public access block).
- Terraform outputs (the site URL).
- `default_tags` on the provider — a habit from day 1.
