# ==========================================================================
# The "endpoint" module — the BODY of the function.
# One instance of this = one full endpoint: its own zip, exec role, log
# group, function, integration, route and invoke permission.
# The shared HTTP API is passed in (var.api_id); it is NOT created here.
#
# Note the local names: everything is called "this". A module is its own
# namespace, so two instances (module.hello, module.users) never collide —
# just like local variables in two calls of the same function.
# ==========================================================================

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

# --- Packaging: zip this endpoint's compiled code ---
data "archive_file" "this" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/build/${var.name}.zip"
}

# --- Execution role: WHO the Lambda is at runtime ---
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "exec" {
  name               = "${var.name}-exec"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

# Minimum permissions: write to this endpoint's own log group only
data "aws_iam_policy_document" "logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]
  }
}

resource "aws_iam_role_policy" "logs" {
  name   = "write-own-logs"
  role   = aws_iam_role.exec.id
  policy = data.aws_iam_policy_document.logs.json
}

# --- Log group: Lambda always logs to /aws/lambda/<function-name>,
# so the name must match var.name exactly ---
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_days
}

# --- The function itself ---
resource "aws_lambda_function" "this" {
  function_name = var.name
  role          = aws_iam_role.exec.arn

  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  runtime = var.runtime
  handler = var.handler

  depends_on = [aws_cloudwatch_log_group.this]
}

# --- Wiring into the SHARED api: integration → route → invoke permission ---
resource "aws_apigatewayv2_integration" "this" {
  api_id                 = var.api_id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.this.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = var.api_id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  # Only this shared API (any stage, any route) may invoke this function
  source_arn = "${var.api_execution_arn}/*/*"
}
