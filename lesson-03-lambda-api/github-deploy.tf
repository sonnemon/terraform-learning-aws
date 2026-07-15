# ==========================================================================
# GitHub Actions deploy role for lesson-03.
#
# This is the DEPLOY role: the identity the CI runner assumes (via OIDC) to
# run `terraform apply`. It is NOT the lambda_exec role in main.tf — that one
# is the identity the function wears at runtime. Two roles, two jobs.
#
# The OIDC provider (the "door") is account-wide and already exists from
# lesson-01, so here we only REFERENCE it (data source) and hang a new,
# lesson-scoped role off it. One door, one role per project.
#
# Bootstrap note: the first `apply` that creates this role must run locally
# (with your admin credentials). After that, the runner can assume it.
# ==========================================================================

data "aws_caller_identity" "current" {}

# The existing account-wide OIDC provider — created in lesson-01, reused here.
# We look it up by URL instead of recreating it (only one is allowed per URL).
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  account_id     = data.aws_caller_identity.current.account_id
  state_bucket   = "tf-state-terraform-learning-aws"
  state_key_glob = "lesson-03-lambda-api/*" # state file + .tflock live here
}

# --------------------------------------------------------------------------
# Trust policy — WHO can assume this role: only this repo, only on main.
# Same shape as lesson-01, just pointed at the shared provider via data.
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "github_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:sonnemon/terraform-learning-aws:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_deploy" {
  name               = "lesson-03-github-deploy"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

# --------------------------------------------------------------------------
# Permissions — WHAT the role can do: exactly the services this lesson's
# `apply` touches (state bucket, Lambda, its exec role, API Gateway, logs).
# Scoped to lesson-03 resource names wherever AWS allows resource-level ARNs.
# A few Describe/List actions only accept "*" and are grouped separately.
# --------------------------------------------------------------------------
data "aws_iam_policy_document" "github_deploy" {

  # --- Terraform remote state (S3 backend + native lock file) ---
  statement {
    sid       = "StateBucketList"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.state_bucket}"]
  }
  statement {
    sid = "StateObjectRW"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["arn:aws:s3:::${local.state_bucket}/${local.state_key_glob}"]
  }

  # --- The Lambda function itself ---
  statement {
    sid = "ManageLambda"
    actions = [
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      # extra reads the provider does when refreshing a function
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:GetFunctionConcurrency",
      "lambda:GetRuntimeManagementConfig",
      "lambda:ListVersionsByFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:TagResource",
      "lambda:UntagResource",
      "lambda:ListTags",
      # resource-based policy (who may invoke) — the aws_lambda_permission
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:GetPolicy",
    ]
    resources = ["arn:aws:lambda:us-east-1:${local.account_id}:function:lesson-03-*"]
  }

  # --- The lambda_exec role in main.tf ---
  # Powerful: creating/altering IAM roles is a privilege-escalation surface,
  # so it is fenced to role names starting with "lesson-03-". PassRole is what
  # lets `apply` attach the exec role to the function.
  statement {
    sid = "ManageLambdaExecRole"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
    ]
    resources = ["arn:aws:iam::${local.account_id}:role/lesson-03-*"]
  }

  # --- CloudWatch Logs (the log group + its retention) ---
  statement {
    sid = "ManageLogGroup"
    actions = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource",
    ]
    # Two ARN forms: with ":*" for stream-level actions (Create/Put/Delete),
    # and WITHOUT ":*" for the tag actions (Tag/Untag/ListTagsForResource),
    # which target the log group resource ARN itself.
    resources = [
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/lesson-03-*",
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/lesson-03-*:*",
    ]
  }

  # --- API Gateway (HTTP API + integration + route + stage) ---
  # apigateway ARNs are by REST path, and the api id is unknown until created,
  # so this covers "/apis" and everything under it.
  statement {
    sid = "ManageApiGateway"
    actions = [
      "apigateway:GET",
      "apigateway:POST",
      "apigateway:PUT",
      "apigateway:PATCH",
      "apigateway:DELETE",
      "apigateway:TagResource",
      "apigateway:UntagResource",
    ]
    resources = [
      "arn:aws:apigateway:us-east-1::/apis",
      "arn:aws:apigateway:us-east-1::/apis/*",
    ]
  }

  # --- Read the shared OIDC provider (github-deploy.tf's own data source) ---
  # The role manages a config that references the OIDC provider, so it must be
  # able to read it. Get can be scoped to the provider ARN...
  statement {
    sid       = "ReadOIDCProvider"
    actions   = ["iam:GetOpenIDConnectProvider"]
    resources = ["arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"]
  }

  # --- Read-only actions that AWS only accepts on "*" ---
  # These don't expose anything sensitive; they let `plan` see current state.
  # (ListOpenIDConnectProviders can't be scoped — the data source lists all,
  #  then filters by URL.)
  statement {
    sid = "DescribeOnAny"
    actions = [
      "logs:DescribeLogGroups",
      "lambda:GetAccountSettings",
      "iam:ListOpenIDConnectProviders",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_deploy" {
  name   = "deploy-lesson-03"
  role   = aws_iam_role.github_deploy.id
  policy = data.aws_iam_policy_document.github_deploy.json
}
