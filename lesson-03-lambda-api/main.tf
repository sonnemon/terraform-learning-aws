terraform {
  backend "s3" {
    bucket  = "tf-state-terraform-learning-aws"
    key     = "lesson-03-lambda-api/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.54.0"
    }
    # Utility provider: turns the compiled app into the zip Lambda expects.
    # Used inside the endpoint module, but declared here for the root too.
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

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

# --------------------------------------------------------------------------
# Shared HTTP API — the single public front door for ALL endpoints.
# One api + one stage, created once here. Each endpoint (see endpoints.tf)
# hangs its own integration + route off this api via the "endpoint" module.
# --------------------------------------------------------------------------

resource "aws_apigatewayv2_api" "main" {
  name          = "lesson-03-api"
  protocol_type = "HTTP"
}

# $default is the no-name stage: the API lives at the bare URL, no /stage
# prefix. auto_deploy means route/integration changes go live on apply.
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}
