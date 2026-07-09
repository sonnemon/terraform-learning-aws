# Lesson 07 — CI/CD with OIDC · $0.00

## Services

- **IAM OIDC Provider:** tells AWS "trust the tokens issued by GitHub Actions". The foundation for authenticating without stored credentials.
- **IAM Role (trust policy to GitHub):** the role the workflow assumes. The trust policy is restricted to this repo and branch: `repo:sonneum/terraform-aws-learning:ref:refs/heads/main`.
- **GitHub Actions:** the CI. Runs `fmt`, `validate` and `plan` on every PR.
- **GitHub Environments:** allow requiring manual approval before an apply.

## Example project

A Terraform pipeline with zero AWS secrets:

```
PR → Actions → OIDC token → assumes IAM role (~1h) → terraform plan → posts the plan as a PR comment
```

1. Create the OIDC provider + role with a restricted trust policy.
2. `terraform-ci.yml` workflow: fmt + validate + plan only on changed folders (`dorny/paths-filter` + dynamic matrix).
3. Add `tflint` + `trivy`/`checkov` (IaC security scanning).
4. `manual-ops.yml` workflow: `workflow_dispatch` with a lesson + action choice (plan/apply/destroy) — an emergency button that works from your phone.
5. Pin all actions to commit SHAs, not tags.

**Design decision:** CI only runs `plan`; apply/destroy is always manual. Editing an old lesson never re-deploys it.

## What you learn

- Credential-less authentication (zero AWS secrets in GitHub).
- Restricted trust policies.
- CI that only runs what changed.
- IaC security scanning.
