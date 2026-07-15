# ==========================================================================
# Inputs of the "endpoint" module — the parameters of the function.
# Everything that changes from one endpoint to the next lives here.
# ==========================================================================

variable "name" {
  description = "Full function name, e.g. \"lesson-03-hello\". Also drives the log group (/aws/lambda/<name>) and the exec role name."
  type        = string
}

variable "source_dir" {
  description = "Directory with the compiled code to zip (the Lambda's dist folder)."
  type        = string
}

variable "route_key" {
  description = "API Gateway route this endpoint answers, e.g. \"GET /hello\"."
  type        = string
}

variable "api_id" {
  description = "ID of the SHARED HTTP API this endpoint attaches to (created in the root module)."
  type        = string
}

variable "api_execution_arn" {
  description = "execution_arn of the shared HTTP API — used to scope the invoke permission."
  type        = string
}

# --- Optional inputs, with sensible defaults (like default args in a function) ---

variable "handler" {
  description = "Lambda handler as <file>.<export>, e.g. \"index.handler\"."
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime identifier."
  type        = string
  default     = "nodejs22.x"
}

variable "log_retention_days" {
  description = "How long CloudWatch keeps this endpoint's logs."
  type        = number
  default     = 7
}
