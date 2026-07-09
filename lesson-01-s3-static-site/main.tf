terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.54.0"
    }
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      project     = "terraform-learning-aws"
      environment = "learning"
      managed-by  = "terraform"
    }
  }
}

resource "aws_s3_bucket" "carlos_static_site" {
  bucket = "carlos-static-site-${data.aws_caller_identity.current.account_id}"
}

# --------------------------------------------------------------------------
# GitHub Actions OIDC — lets the deploy workflow get temporary AWS
# credentials without any stored secrets. One provider per AWS account
# (will move to lesson-07 later).
# --------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Trust policy: WHO can assume the role — only workflows from this repo,
# running on main
data "aws_iam_policy_document" "github_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
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
  name               = "lesson-01-github-deploy"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

# Permissions policy: WHAT the role can do — sync files to the site bucket,
# nothing else. Note the two ARN levels: the bucket itself for ListBucket,
# bucket/* for object operations.
data "aws_iam_policy_document" "github_deploy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.carlos_static_site.arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${aws_s3_bucket.carlos_static_site.arn}/*"]
  }
}

resource "aws_iam_role_policy" "github_deploy" {
  name   = "deploy-to-site-bucket"
  role   = aws_iam_role.github_deploy.id
  policy = data.aws_iam_policy_document.github_deploy.json
}

