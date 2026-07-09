# Lesson 09 — Environments · $0.00

## Services

Same as lesson-08, deployed twice (dev and prod). No new services: the lesson is how a single codebase serves multiple environments.

## Example project

The notes API in dev and prod:

```
lesson-09-environments/
├── main.tf            # single codebase (uses the modules from 08)
├── dev.tfvars         # small memory, names suffixed -dev
├── prod.tfvars        # bigger memory, names suffixed -prod
└── backend.tf         # different state key per environment
```

1. Parameterize everything that differs between environments (names, sizes, log retention).
2. Separate state: `key = "lesson-09/dev/terraform.tfstate"` and `.../prod/...`.
3. Deploy dev: `terraform apply -var-file=dev.tfvars`.
4. Deploy prod with the SAME code, different tfvars.
5. Verify both coexist without stepping on each other.

## What you learn

- One codebase for multiple environments.
- Per-environment tfvars + separate backend keys.
- Differentiated configuration without duplicating code.
