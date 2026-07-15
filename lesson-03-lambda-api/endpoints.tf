# ==========================================================================
# Endpoints — one `module` block per endpoint. Same module (./modules/
# endpoint), different values. This is where you "call the function".
#
# To add an endpoint: copy the block, change name / source_dir / route_key
# (and handler if needed). Everything else — role, logs, integration,
# route, permission — the module builds for you.
# ==========================================================================

module "hello" {
  source = "./modules/endpoint"

  name       = "lesson-03-hello"
  source_dir = "${path.module}/app/dist"
  route_key  = "GET /hello"
  handler    = "index.handler"

  # The shared api from main.tf
  api_id            = aws_apigatewayv2_api.main.id
  api_execution_arn = aws_apigatewayv2_api.main.execution_arn
}


module "users" {
  source = "./modules/endpoint"

  name       = "lesson-03-users"
  source_dir = "${path.module}/app/dist"
  route_key  = "GET /users"
  handler    = "users.handler"


  # The shared api from main.tf
  api_id            = aws_apigatewayv2_api.main.id
  api_execution_arn = aws_apigatewayv2_api.main.execution_arn
}

module "roles" {
  source = "./modules/endpoint"

  name       = "lesson-03-roles"
  source_dir = "${path.module}/app/dist"
  route_key  = "GET /roles"
  handler    = "roles.handler"

  # The shared api from main.tf
  api_id            = aws_apigatewayv2_api.main.id
  api_execution_arn = aws_apigatewayv2_api.main.execution_arn
}