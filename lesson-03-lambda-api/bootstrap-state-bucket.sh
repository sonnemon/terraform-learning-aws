#!/usr/bin/env bash
#
# Bootstrap SHARED, account-wide infrastructure that every lesson depends on
# but no single lesson should OWN (so `terraform destroy` on a lesson can't
# take it down). Run this ONCE, by hand, before `terraform init`.
#
#   1. The S3 bucket that stores Terraform remote state.
#   2. The GitHub Actions OIDC provider (the "door") that lets CI assume roles.
#
# Both live outside Terraform's lifecycle (chicken-and-egg + shared-resource).
#
set -euo pipefail

# --- Config -----------------------------------------------------------------
BUCKET="tf-state-terraform-learning-aws"  # must be globally unique across AWS
REGION="us-east-1"                         # us-east-1 needs no LocationConstraint

OIDC_URL="token.actions.githubusercontent.com"          # GitHub's OIDC issuer
OIDC_CLIENT_ID="sts.amazonaws.com"                       # audience AWS expects
OIDC_THUMBPRINT="6938fd4d98bab03faadb97b34396831e3780aea1" # GitHub's cert thumbprint
# ----------------------------------------------------------------------------

echo "==> Bucket: $BUCKET"
echo "==> Region: $REGION"

# Create the bucket only if it does not already exist (idempotent).
if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
  echo "==> Bucket already exists, skipping creation."
else
  echo "==> Creating bucket..."
  aws s3api create-bucket \
    --bucket "$BUCKET" \
    --region "$REGION"
fi

echo "==> Enabling versioning (safety net for corrupted state)..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET" \
  --versioning-configuration Status=Enabled

echo "==> Blocking all public access..."
aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "==> Enabling default encryption at rest (AES256)..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET" \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# ----------------------------------------------------------------------------
# GitHub Actions OIDC provider — the shared "door". Account-wide: only ONE
# per URL is allowed. Lessons reference it via a data source, they don't own
# it, so destroying a lesson never removes it.
# ----------------------------------------------------------------------------
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
OIDC_ARN="arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_URL}"

echo ""
if aws iam get-open-id-connect-provider --open-id-connect-provider-arn "$OIDC_ARN" >/dev/null 2>&1; then
  echo "==> OIDC provider already exists, skipping creation."
else
  echo "==> Creating GitHub OIDC provider..."
  aws iam create-open-id-connect-provider \
    --url "https://${OIDC_URL}" \
    --client-id-list "$OIDC_CLIENT_ID" \
    --thumbprint-list "$OIDC_THUMBPRINT"
fi

echo ""
echo "==> Done. Verifying:"
aws s3api get-bucket-versioning --bucket "$BUCKET"
echo "==> Bucket ready:  s3://$BUCKET"
echo "==> OIDC provider: $OIDC_ARN"
