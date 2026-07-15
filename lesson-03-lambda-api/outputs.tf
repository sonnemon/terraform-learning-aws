output "api_url" {
  description = "Base URL of the shared HTTP API"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "hello_url" {
  description = "The endpoint to curl"
  value       = "${aws_apigatewayv2_api.main.api_endpoint}/hello"
}

output "log_group" {
  description = "Where the hello Lambda's console.log output lands"
  value       = module.hello.log_group_name
}

output "deploy_role_arn" {
  description = "Role GitHub Actions assumes — goes into the LESSON_03_DEPLOY_ROLE_ARN GitHub variable"
  value       = aws_iam_role.github_deploy.arn
}
