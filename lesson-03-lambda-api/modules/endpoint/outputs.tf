# ==========================================================================
# Outputs of the "endpoint" module — the return value of the function.
# The root module reads these as module.<name>.<output>; the internal
# resources stay encapsulated.
# ==========================================================================

output "function_name" {
  description = "Name of the created Lambda function."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the created Lambda function."
  value       = aws_lambda_function.this.arn
}

output "log_group_name" {
  description = "CloudWatch log group where this endpoint's logs land."
  value       = aws_cloudwatch_log_group.this.name
}

output "route_key" {
  description = "The API Gateway route this endpoint answers."
  value       = aws_apigatewayv2_route.this.route_key
}
