output "site_url" {
  description = "Public URL of the static site"
  value       = "http://${aws_s3_bucket_website_configuration.carlos_static_site.website_endpoint}"
}

output "bucket_name" {
  description = "Site bucket name — goes into the LESSON_01_BUCKET GitHub variable"
  value       = aws_s3_bucket.carlos_static_site.id
}

output "deploy_role_arn" {
  description = "Role GitHub Actions assumes — goes into the LESSON_01_DEPLOY_ROLE_ARN GitHub variable"
  value       = aws_iam_role.github_deploy.arn
}
